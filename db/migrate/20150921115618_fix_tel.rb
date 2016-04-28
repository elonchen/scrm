class FixTel < ActiveRecord::Migration
  def change
  	Customer.find_each do |customer|
      if customer.tel.present? && customer.tel =~ /\A\d+\Z/
        customer.phones.create(number: customer.tel)
      end
    end
  end
end
