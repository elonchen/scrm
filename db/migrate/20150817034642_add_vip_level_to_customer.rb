class AddVipLevelToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :vip_level, :string, default: :normal
  end
end
