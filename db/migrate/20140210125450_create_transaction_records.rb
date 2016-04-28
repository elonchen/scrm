class CreateTransactionRecords < ActiveRecord::Migration
  def change
    create_table :transaction_records do |t|
      t.references :product, index: true
      t.references :member, index: true
      t.references :customer, index: true
      t.decimal :amount, :precision => 8, :scale => 2
      t.references :note, index: true
      t.integer :saler_id, index: true
      t.text :description
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
