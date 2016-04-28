class AddMemberToCustomer < ActiveRecord::Migration
  def change
    add_reference :customers, :member, index: true
    add_column :members, :customers_count, :integer, default:0
  end
end
