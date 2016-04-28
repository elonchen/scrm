class CreateCommunications < ActiveRecord::Migration
  def change
    create_table :communications do |t|
      t.integer :member_id
      t.string :callee_type  # 被叫者 类型 Customer, Member, Direct
      t.integer :callee_id  # 被叫者 Id，如果是直呼电话号码，是没有 id 的。
      t.integer :calltype
      t.string :caller
      t.integer :byetype
      t.string :recordurl
      t.string :callSid
      t.datetime :starttime
      t.datetime :endtime
      t.string :called
      t.string :billdata

      t.timestamps
    end

    add_index :communications, :member_id
    add_index :communications, [:callee_type, :callee_id]
    add_index :communications, :caller
    add_index :communications, :created_at

    add_index :customers, :tel unless index_exists? :customers, :tel
  end
end
