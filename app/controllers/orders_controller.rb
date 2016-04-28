class OrdersController < ApplicationController
  before_filter :check_for_admin, only: :close
  before_filter :set_order, only: [:close, :show]
  def index
    @q = Order.search(params[:q])
    @orders = @q.result(distinct: true).paginate(page: params[:page] || 1 , per_page: params[:per_page] || 20)
  end

  def show
  end

  def close
    @order.close!
    redirect_to request.referer
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end
end
