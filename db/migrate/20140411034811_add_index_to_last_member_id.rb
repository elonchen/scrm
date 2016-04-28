class AddIndexToLastMemberId < ActiveRecord::Migration
  def change
    add_index :customers, :last_member_id
  end
end
