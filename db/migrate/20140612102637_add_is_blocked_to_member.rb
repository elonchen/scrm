class AddIsBlockedToMember < ActiveRecord::Migration
  def change
    add_column :members, :is_blocked, :boolean, default: false
  end
end
