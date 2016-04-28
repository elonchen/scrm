class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.text :content
      t.references :customer
      t.references :member
      t.string :from_state
      t.string :to_state
      t.string :event
      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
