require 'test_helper'

class ProductAssociationsControllerTest < ActionController::TestCase
  setup do
    @product_association = product_associations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_associations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_association" do
    assert_difference('ProductAssociation.count') do
      post :create, product_association: { product_associate_type_id: @product_association.product_associate_type_id, product_type_id: @product_association.product_type_id }
    end

    assert_redirected_to product_association_path(assigns(:product_association))
  end

  test "should show product_association" do
    get :show, id: @product_association
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_association
    assert_response :success
  end

  test "should update product_association" do
    patch :update, id: @product_association, product_association: { product_associate_type_id: @product_association.product_associate_type_id, product_type_id: @product_association.product_type_id }
    assert_redirected_to product_association_path(assigns(:product_association))
  end

  test "should destroy product_association" do
    assert_difference('ProductAssociation.count', -1) do
      delete :destroy, id: @product_association
    end

    assert_redirected_to product_associations_path
  end
end
