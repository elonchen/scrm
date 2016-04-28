class AddCreatedAtIndexToActivity < ActiveRecord::Migration
  def change
    add_index :activities, :created_at
    add_index :customers, :last_updated_at
    add_index :customers, :workflow_state
    add_index :customers, :created_at
    add_index :notes, :created_at
    add_index :members, :created_at
  end
end
