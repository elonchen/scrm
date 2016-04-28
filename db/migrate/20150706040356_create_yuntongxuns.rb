class CreateYuntongxuns < ActiveRecord::Migration
  def change
    create_table :yuntongxuns do |t|
      t.integer :member_id
      t.string :token
      t.string :voipid
      t.string :voippwd

      t.timestamps
    end

    add_index :yuntongxuns, :member_id
    add_index :yuntongxuns, :token
    add_index :yuntongxuns, :voipid

  end
end
