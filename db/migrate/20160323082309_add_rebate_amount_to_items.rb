class AddRebateAmountToItems < ActiveRecord::Migration
  def change
    add_column :items, :rebate_amount, :decimal
  end
end
