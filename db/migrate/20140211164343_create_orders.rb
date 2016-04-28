class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :human_order_id, index: true
      t.references :note
      t.decimal :amount, :precision=>8, :scale=>2
      t.string :workflow_state, index: true
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
