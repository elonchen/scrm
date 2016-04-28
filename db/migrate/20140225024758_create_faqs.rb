class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.string :title, index: true
      t.references :member, index: true
      t.text :question
      t.text :answer
      t.timestamps
    end
  end
end
