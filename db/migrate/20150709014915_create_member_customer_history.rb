class CreateMemberCustomerHistory < ActiveRecord::Migration
  def change
    create_table :member_customer_histories do |t|
      t.integer :member_id
      t.integer :customer_id
      t.string :last_state
      t.datetime :last_updated_at
      t.timestamps
    end

    add_index :member_customer_histories, :member_id
    add_index :member_customer_histories, :customer_id
  end
end
