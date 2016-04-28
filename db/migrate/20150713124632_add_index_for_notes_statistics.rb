class AddIndexForNotesStatistics < ActiveRecord::Migration
  def change
    add_index :notes, :customer_id
    add_index :notes, :member_id
  end
end
