class CreateNavigations < ActiveRecord::Migration
  def change
    create_table :navigations do |t|
      t.string :name
      t.string :link

      t.timestamps
    end
  end
end
