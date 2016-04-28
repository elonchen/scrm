require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  setup do
    @item = items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item" do
    assert_difference('Item.count') do
      post :create, item: { amount: @item.amount, applier_id: @item.applier_id, approver_id: @item.approver_id, customer_id: @item.customer_id, ddb_account_id: @item.ddb_account_id, description: @item.description, name: @item.name, products_id: @item.products_id, saler_id: @item.saler_id, time_gap: @item.time_gap, type: @item.type }
    end

    assert_redirected_to item_path(assigns(:item))
  end

  test "should show item" do
    get :show, id: @item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @item
    assert_response :success
  end

  test "should update item" do
    patch :update, id: @item, item: { amount: @item.amount, applier_id: @item.applier_id, approver_id: @item.approver_id, customer_id: @item.customer_id, ddb_account_id: @item.ddb_account_id, description: @item.description, name: @item.name, products_id: @item.products_id, saler_id: @item.saler_id, time_gap: @item.time_gap, type: @item.type }
    assert_redirected_to item_path(assigns(:item))
  end

  test "should destroy item" do
    assert_difference('Item.count', -1) do
      delete :destroy, id: @item
    end

    assert_redirected_to items_path
  end
end
