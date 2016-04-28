class AddCustomShareThresholdToMember < ActiveRecord::Migration
  def change
    add_column :members, :customer_share_threshold, :decimal, :precision => 4, :scale=>2, default: 0.05
  end
end
