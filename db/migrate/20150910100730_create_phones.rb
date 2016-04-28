class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.integer :owner_id
      t.string :owner_type
      t.string :number
    end
    add_index :phones, :owner_id
    add_index :phones, :number
  end
end
