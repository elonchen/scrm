class AddConfirmableToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :confirmation_token, :string
    add_column :members, :confirmed_at, :datetime
    add_column :members, :confirmation_sent_at, :datetime
    add_index :members, :confirmation_token, :unique =>true
  end

  def self.down
    remove_columns :members, :confirmation_token, :confirmed_at, :confirmation_sent_at
  end
end
