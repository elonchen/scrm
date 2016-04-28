class AddHasBalanceDueToSaleItem < ActiveRecord::Migration
  def change
    unless column_exists? :items, :has_balance_due
      add_column :items, :has_balance_due, :boolean, default: false, index: true
    end
    unless column_exists? :items, :balance_due
      add_column :items, :balance_due, :decimal, :precision=>8, :scale=>2
    end
    unless column_exists? :items, :due_date
      add_column :items, :due_date, :datetime
    end
    unless column_exists? :items, :due_item_id
      add_column :items, :due_item_id, :integer
    end
  end
end
