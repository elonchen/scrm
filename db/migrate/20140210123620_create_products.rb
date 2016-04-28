class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, :precision => 8, :scale => 2
      t.text :description
      t.datetime :deleted_at
      t.timestamps
    end
  end
end