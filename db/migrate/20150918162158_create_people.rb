class CreatePeople < ActiveRecord::Migration
  def up
    create_table :people do |t|
      t.string :name
      t.string :phone
      t.string :wechat_number
      t.string :pos
      t.references :visit_note, index: true

      t.timestamps
    end

    add_column :notes, :visit_at, :datetime
    add_column :notes, :visit_reason, :string
  end

  def down
    # drop_table :people
    # remove_column :notes, :visit_at
      # remove_column :notes, :visit_reason
  end
end
