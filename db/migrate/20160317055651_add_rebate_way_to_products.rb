class AddRebateWayToProducts < ActiveRecord::Migration
  def change
    add_column :products, :rebate_way, :string
  end
end
