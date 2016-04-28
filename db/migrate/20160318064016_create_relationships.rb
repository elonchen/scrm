class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :manager_id
      t.integer :worker_id

      t.timestamps
    end
    add_index :relationships, :manager_id
    add_index :relationships, :worker_id
    add_index :relationships, [:manager_id, :worker_id], unique: true
  end
end
