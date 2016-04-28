class FixIntroductionToCustomers < ActiveRecord::Migration
  def up
    change_column :customers, :introduction, :text
  end

  def down
  end
end
