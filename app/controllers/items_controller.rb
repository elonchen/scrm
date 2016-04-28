require 'csv'
class ItemsController < ApplicationController
  before_filter :check_for_admin, only: [:accept, :reject, :statistics]
  before_action :set_item, only: [:show, :cancel, :accept, :reject]

  # GET /items
  # GET /items.json
  def index
    @q = type_class.owner_or_partner_of(current_member).ransack(params[:q])
    @items = @q.result.paginate(page: params[:page], :per_page => 25)
  end

  def cancel
    if current_member == @item.applier
      @item.cancel!
      render 'show'
    else
      redirect_to request.referer
    end
  end

  def accept
    @item.accept!(current_member)
    redirect_to request.referer
  end

  def reject
    @item.reject!(current_member, params[:reason])
    redirect_to equest.referer
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = type_class.new
  end

  # POST /items
  # POST /items.json
  def create
    @item = type_class.new(item_params)
    @item.applier = current_member

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render action: 'show', status: :created, location: @item }
      else
        format.html { render action: 'new' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def statistics
    @q = Item.search(params[:q])
    @items = @q.result(distinct: true).with_accepted_state
    @all_items = @items
    @all_sale_items = @items.of_sale_items
    @all_stock_items = @items.of_stock_items
    @accepted_sale_item_amount = @all_sale_items.sum(:amount)
    @accepted_stock_items_amount = @all_stock_items.sum(:amount)
  end

  def export
    @q = Item.search(params[:q])
    @items = @q.result(distinct: true).with_accepted_state
    day_str = DateTime.new.strftime("%Y%m%d%H%M%S")
    respond_to do |format|
      format.csv { send_data Item.to_csv(@items,col_sep: ","), :filename => "items_#{day_str}.csv" }
    end
  end

  def import
    content = request.body.read
    type_class.import(current_member, params[:uploadfile], content)
    render :json => 'ok'
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = type_class.owner_of_(current_member).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      if type == "SaleItem"
        params.require(type.underscore.to_sym).permit(:name, :amount, :description, :transaction_time, :ddb_account_id, :time_gap, :has_balance_due, :balance_due, :due_date, :order_id, :bank_account_id, :partner_id, :invoice)
      else
        params.require(type.underscore.to_sym).permit(:name, :amount, :description, :transaction_time)
      end
    end

    def set_type
      @type = type
    end

    def type
      params[:type]||"Item"
    end

    def type_class
      type.constantize
    end
end