class AddLastMemberToCustomer < ActiveRecord::Migration
  def change
    unless column_exists? :customers, :last_member_id
      add_column :customers, :last_member_id, :integer, index: true
    end
    unless column_exists? :customers, :last_updated_at
      add_column :customers, :last_updated_at, :datetime
    end
    Customer.all.each do |customer|
      if customer.notes.empty?
        customer.update_column(:last_member_id, customer.member.id)
        customer.update_column(:last_updated_at, customer.created_at)
      else
        customer.update_column(:last_member_id, customer.notes.first.member.id)
        customer.update_column(:last_updated_at, customer.notes.first.created_at)
      end
    end
  end
end
