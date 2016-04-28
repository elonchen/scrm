#encoding: utf-8
class CustomersController < ApplicationController
  before_action :set_customer, only: [:edit, :update, :destroy]

  # GET /customers
  # GET /customers.json
  def index
    @q = Customer.ransack(params[:q])
    @customers = @q.result(distinct: true).paginate(page: params[:page], :per_page => 25)
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    @customer = Customer.with_deleted.find(params[:id])
    @notes = @customer.notes
    if @customer.hide_reject_record? and !current_member.has_role?(:admin)
      # 有放弃记录，且当前状态是可领取，隐藏放弃记录
      @notes = @notes.where('member_id = ? or to_state != ?', current_member.id, 'rejected')
    end
  end

  # GET /customers/new
  def new
    @customer = current_member.customers.build
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = current_member.customers.build(customer_params)


    respond_to do |format|
      unless current_member.in_customer_share_threshold?
        @customer.last_member =Member.find_member_in_customer_share_threshold(current_member)
      end

      if @customer.save
        format.html { redirect_to @customer, notice: 'Customer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @customer }
      else
        format.html { render action: 'new' }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
    end
  end

  def import
    result = Customer.import_from_csv(current_member, params[:file])
    render :json => result
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      if action_name == "create" or current_member.has_role?(:admin)
        params.require(:customer).permit(:name, :wechat_number, :email, :qq, :from, :vip_level, :shop_type, :introduction, :is_agent, :agent_type, :last_member_id, :province, :city, :level, :zone_ids=>[], phones_attributes:[:id, :number,:_destroy])
      else
        params.require(:customer).permit(:name, :wechat_number, :email, :qq, :vip_level, :shop_type, :introduction, :is_agent, :agent_type, :last_member_id,:province, :city, :level, :zone_ids=>[], phones_attributes:[:id, :number,:_destroy])
      end
    end
end
