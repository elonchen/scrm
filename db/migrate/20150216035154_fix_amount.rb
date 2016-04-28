class FixAmount < ActiveRecord::Migration
  def change
    change_column :items, :amount, :decimal, :precision => 10, :scale => 2
  end
end
