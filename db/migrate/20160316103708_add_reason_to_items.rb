class AddReasonToItems < ActiveRecord::Migration
  def change
    add_column :items, :reason, :string
  end
end
