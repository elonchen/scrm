class AddBankCardTypeToMember < ActiveRecord::Migration
  def change
    add_column :members, :bank_card_type, :string
    add_column :members, :bank_card_number, :string
  end
end
