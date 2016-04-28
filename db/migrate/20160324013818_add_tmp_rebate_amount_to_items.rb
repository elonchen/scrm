class AddTmpRebateAmountToItems < ActiveRecord::Migration
  def change
    add_column :items, :tmp_rebate_amount, :decimal
  end
end
