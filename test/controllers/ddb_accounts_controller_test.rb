require 'test_helper'

class DdbAccountsControllerTest < ActionController::TestCase
  setup do
    @ddb_account = ddb_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ddb_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ddb_account" do
    assert_difference('DdbAccount.count') do
      post :create, ddb_account: { customer_id: @ddb_account.customer_id, email: @ddb_account.email, member_id: @ddb_account.member_id, name: @ddb_account.name, slug: @ddb_account.slug, title: @ddb_account.title }
    end

    assert_redirected_to ddb_account_path(assigns(:ddb_account))
  end

  test "should show ddb_account" do
    get :show, id: @ddb_account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ddb_account
    assert_response :success
  end

  test "should update ddb_account" do
    patch :update, id: @ddb_account, ddb_account: { customer_id: @ddb_account.customer_id, email: @ddb_account.email, member_id: @ddb_account.member_id, name: @ddb_account.name, slug: @ddb_account.slug, title: @ddb_account.title }
    assert_redirected_to ddb_account_path(assigns(:ddb_account))
  end

  test "should destroy ddb_account" do
    assert_difference('DdbAccount.count', -1) do
      delete :destroy, id: @ddb_account
    end

    assert_redirected_to ddb_accounts_path
  end
end
