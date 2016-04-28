class AddWechatNumberToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :wechat_number, :string
  end
end
