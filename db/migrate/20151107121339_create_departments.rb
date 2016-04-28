class CreateDepartments < ActiveRecord::Migration
  def up
  	unless ActiveRecord::Migration.table_exists? :departments
	    create_table :departments do |t|
	      t.string :name
	      t.integer :members_count, default: 0
        t.integer :items_count, default: 0
	      t.timestamps
	    end
	end

	unless column_exists? :members, :department_id 
    	add_reference :members, :department, index: true
    end

    unless column_exists? :items, :department_id
    	add_reference :items, :department, index: true
    end

  end

  def down
  	if ActiveRecord::Migration.table_exists? :departments
	    drop_table :departments
	end

	if column_exists? :members, :department_id 
    	remove_reference :members, :department
    end

    if column_exists? :items, :department_id
    	remove_reference :items, :department
    end
  end
end
