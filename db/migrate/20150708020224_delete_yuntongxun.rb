class DeleteYuntongxun < ActiveRecord::Migration
  def change
    drop_table :yuntongxuns
    drop_table :communications
  end
end
