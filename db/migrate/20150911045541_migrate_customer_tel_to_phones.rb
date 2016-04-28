class MigrateCustomerTelToPhones < ActiveRecord::Migration
  def change
    Customer.find_each do |customer|
      if customer.tel.present?
        customer.phones.create(number: customer.tel)
      end
    end
  end
end
