class FixUpdatedAtToCustomer < ActiveRecord::Migration
  def change
  	index = 0 
  	Customer.find_each do |customer|
  		if index % 100 == 0
  			puts "start to migrate the #{index}th customer of #{customer.id}"
  		end
  		if customer.notes.blank?
  			customer.update_column(:updated_at, customer.created_at)
  		else
  			customer.update_column(:updated_at, customer.notes.first.created_at)
  		end
  		
  		index += 1 
  	end
  end
end
