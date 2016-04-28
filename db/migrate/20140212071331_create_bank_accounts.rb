class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :name
      t.references :owner, index: true
      t.text :description
      t.timestamps
    end
    add_reference :items, :bank_account
  end
end
