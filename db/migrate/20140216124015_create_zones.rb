class CreateZones < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? :zones
      create_table :zones do |t|
        t.string :name
        t.string :zone_type
        t.integer :parent_zone_id
        t.timestamps
      end
    end

    unless ActiveRecord::Base.connection.table_exists? :customers_zones
      create_table :customers_zones do |t|
        t.belongs_to :zone
        t.belongs_to :customer
      end
    end

    unless column_exists? :ddb_accounts, :zone_id
      add_column :ddb_accounts, :zone_id, :integer
    end

    unless column_exists? :customers, :is_agent
      add_column :customers, :is_agent, :boolean, default: false
    end
    unless column_exists? :customers, :agent_type
      add_column :customers, :agent_type, :string
    end
  end
end
