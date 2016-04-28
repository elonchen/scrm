class AddLockableToMember < ActiveRecord::Migration
 def change
    add_column :members, :failed_attempts, :integer, default: 0
    add_column :members, :unlock_token, :string
    add_column :members, :locked_at, :datetime
  end
end
