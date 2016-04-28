class AddRebateValueToProducts < ActiveRecord::Migration
  def change
    add_column :products, :rebate_value, :decimal
  end
end
