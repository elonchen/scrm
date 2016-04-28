class CreateAlarm < ActiveRecord::Migration
  def change
    create_table :alarms do |t|
      t.integer :member_id
      t.datetime :time
      t.string :description
      t.string :state, default: :new
      t.integer :owner_id
      t.string :owner_type
      t.timestamps
    end

    add_index :alarms, [:owner_type, :owner_id]
    add_index :alarms, :time
    add_index :alarms, :state
  end
end
