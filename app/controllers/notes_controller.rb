#encoding: utf-8
class NotesController < ApplicationController
  before_action :set_customer, except: [:statistics, :statistics_by_day]
  before_action :set_note, only: [:edit, :update, :destroy]
  before_action :check_for_admin, only: [:statistics, :statistics_by_day]

  def edit

  end

  def update
    
    if @note.update(note_params)
      redirect_to customer_url(@customer), :notice  => "Successfully updated note."
    else
      render :action => 'edit'
    end
  end

  def new
    @note = type_class.new 
    if @note.is_visit_note?
      @note.build_person
    end
  end

  def create
    @note = type_class.new(note_params)
    @note.customer = @customer
    @note.from_state = @customer.current_state.to_s
    @note.to_state = @customer.current_state.to_s
    @note.member = current_member
    @note.transaction_records.each do |transaction_record|
      transaction_record.customer = @customer
      transaction_record.member = current_member
      transaction_record.note = @note
    end
    unless @customer.can_manage_by(current_member)
        @note.errors.add(:base, "最后一个沟通记录距今不足5天或您已经超出您能接管的客户份额，您暂时无法接管该客户")
        render :action => 'new'
        return
    end
    @note.alarms.each do |alarm|
      alarm.member = current_member
      alarm.delete unless alarm.description.present?
    end
    if @note.save
      redirect_to customer_url(@customer), :notice => "Successfully created note."
    else
      render :action => 'new'
    end
  end

  def destroy
    @note.destroy
    redirect_to customer_url(@customer), :notice => "Successfully destroyed note."
  end

  def statistics
    @q = Note.unscoped.ransack(params[:q])

    # 统计对每个 member 的 customer_count 和 note_count
    # 数据中有 member_id, name, customer_count, note_count
    if params[:q].present?
      @first = DateTime.parse(params[:q][:created_at_gteq]) rescue  Time.now.beginning_of_month
      @last = DateTime.parse(params[:q][:created_at_lteq]) rescue Time.now.end_of_month
    end

    @first = Time.now.beginning_of_month unless @first.present?
    @last = Time.now.end_of_month unless @last.present?

    @results = Note.unscoped
                   .where(:updated_at => @first..@last)
                   .joins(:member)
                   .order(:member_id => :asc)
                   .group(:member_id)
                   .select('member_id, members.name, count(distinct customer_id) customer_count, count(*) note_count')
                   .paginate(page: params[:page], per_page: params[:per_page] || 25)
  end

  def statistics_by_day
    @q = Note.unscoped.ransack(params[:q])
    # 统计对每个 member 的 customer_count 和 note_count
    # 数据中有 member_id, name, customer_count, note_count
    if params[:q].present?
      @first = DateTime.parse(params[:q][:created_at_gteq]) rescue  Time.now.beginning_of_month
      @last = DateTime.parse(params[:q][:created_at_lteq]) rescue Time.now.end_of_month
    end

    @first = Time.now.beginning_of_month unless @first.present?
    @last = Time.now.end_of_month unless @last.present?

    @first = Date.new(@first.year, @first.month, @first.day)
    @last = Date.new(@last.year, @last.month, @last.day)
    @results = []
    @members = Set.new
    (@first..@last).each do |day|
      results = Note.unscoped
          .where(:updated_at => day.beginning_of_day .. day.end_of_day)
          .joins(:member)
          .order(:member_id => :asc)
          .group(:member_id)
          .select('member_id, members.name, count(distinct customer_id) customer_count, count(*) note_count')
          # .paginate(page: params[:page], per_page: params[:per_page] || 25)
      @results << {
          date: day,
          results: results
      }

      @members.merge(results.map {|it| it.name})

    end




  end

  private
  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def set_note
    @note = type_class.of_customer_id(@customer.id).find(params[:id])
  end


  def type
    params[:type]||"Note"
  end

  def type_class
    type.constantize
  end

  def note_params
    if action_name == 'create'
      params.require(type.underscore.to_sym).permit(:content, :event, :visit_at, :visit_reason,
                                   transaction_records_attributes: [:product_id, :amount, :saler_id, :_destroy],
                                   alarms_attributes: [:id, :time, :ahead, :description, :_destroy],
                                   person_attributes: [:id, :name, :phone, :wechat_number, :pos]
      )
    else
      params.require(type.underscore.to_sym).permit(:content,:visit_at, :visit_reason,
                                   transaction_records_attributes: [:product_id, :amount, :saler_id, :_destroy],
                                   alarms_attributes: [:id, :time, :ahead, :description, :_destroy],
                                   person_attributes: [:id, :name, :phone, :wechat_number, :pos]
      )
    end
  end
end
