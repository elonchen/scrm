require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Order.first
    assert_template 'show'
  end
end
