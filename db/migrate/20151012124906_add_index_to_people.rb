class AddIndexToPeople < ActiveRecord::Migration
  def change
    add_index :people, :created_at
  end
end
