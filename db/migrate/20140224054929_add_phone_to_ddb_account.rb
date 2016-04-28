class AddPhoneToDdbAccount < ActiveRecord::Migration
  def change
    add_column :ddb_accounts, :phone, :string, index:true
  end
end
