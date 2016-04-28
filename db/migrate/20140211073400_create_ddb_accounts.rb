class CreateDdbAccounts < ActiveRecord::Migration
  def change
    create_table :ddb_accounts do |t|
      t.string :name
      t.references :customer, index: true
      t.string :email
      t.string :slug
      t.string :title
      t.references :member, index: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
