class AddInvoiceToItem < ActiveRecord::Migration
  def change
    add_column :items, :invoice, :string, index: true
  end
end
