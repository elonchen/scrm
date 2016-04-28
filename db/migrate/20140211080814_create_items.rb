class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :type
      t.decimal :amount
      t.references :saler, index: true
      t.references :product, index: true
      t.text :description
      t.references :customer, index: true
      t.references :ddb_account, index: true
      t.string :time_gap
      t.references :applier, index: true
      t.references :approver, index: true
      t.string :workflow_state
      t.datetime :deleted_at
      t.datetime :transaction_time

      t.timestamps
    end
  end
end
