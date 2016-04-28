class AddOrderIdToSaleItem < ActiveRecord::Migration
  def change
    add_reference :items, :order, index: true
  end
end
