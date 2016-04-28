class AddHistoricalRejectsToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :historical_rejects, :integer, default: 0 unless column_exists? :customers, :historical_rejects
    i = 0
    Customer.find_each do |customer|
      i += 1
      if i % 100 == 0
        puts "updated 100 customers, next: #{customer.try(:id)}"
      end
      count = customer.member_customer_histories.where(last_state: 'rejected').uniq(:member_id).count
      customer.update_column(:historical_rejects, count) if count > 0
    end
  end
end
