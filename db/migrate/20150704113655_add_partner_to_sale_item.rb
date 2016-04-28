class AddPartnerToSaleItem < ActiveRecord::Migration
  def change
    add_reference :items, :partner, index: true
  end
end
