class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :tel
      t.string :email
      t.string :qq
      t.string :from
      t.string :introduction

      t.timestamps
    end
  end
end
