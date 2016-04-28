class AddShopTypeToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :shop_type, :string
  end
end
