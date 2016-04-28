class AddAddressToPhone < ActiveRecord::Migration
  def up
    unless column_exists? :customers, :level
      add_column :customers, :level, :integer
    end

    unless column_exists? :customers, :province
      add_column :customers, :province, :string
    end

    unless column_exists? :customers, :city
      add_column :customers, :city, :string, :index => true
    end

    unless index_exists? :customers, [:province, :city]
      add_index :customers, [:province, :city]
    end

  	unless column_exists? :phones, :province
    	add_column :phones, :province, :string
    end
    unless column_exists? :phones, :city
    	add_column :phones, :city, :string, :index => true
    end
    unless column_exists? :phones, :areacode
	    add_column :phones, :areacode, :string, :index => true
    end
    unless column_exists? :phones, :zip
	    add_column :phones, :zip, :string, :index => true
    end
    unless column_exists? :phones, :company
	    add_column :phones, :company, :string
    end
    unless column_exists? :phones, :card
	    add_column :phones, :card, :string
    end
    unless index_exists? :phones, [:province, :city]
	    add_index :phones, [:province, :city]
    end

    index = 1
    Phone.find_each do |phone|
      if index % 100 == 0
        puts "start to migrate phone of #{phone.id}"
      end
    	begin 
    		phone.fix_phone_address
        puts "phone new address #{phone.province}-#{phone.city}"
    	rescue => e
    		puts e
    	end
    end

  end

  def down


    if column_exists? :customers, :level
      remove_column :customers, :level
    end

    if column_exists? :customers, :province
      remove_column :customers, :province
    end
    if column_exists? :customers, :city
      remove_column :customers, :city
    end

    if index_exists? :customers, [:province, :city]
      remove_index :customers, [:province, :city]
    end

  	if column_exists? :phones, :province
  		remove_column :phones, :province
  	end
  	if column_exists? :phones, :city
    	remove_column :phones, :city
  	end
  	if column_exists? :phones, :areacode
    	remove_column :phones, :areacode
  	end
  	if column_exists? :phones, :zip
    	remove_column :phones, :zip
  	end
  	if column_exists? :phones, :company
    	remove_column :phones, :company
  	end
  	if column_exists? :phones, :card
    	remove_column :phones, :card
  	end
  	if index_exists? :phones, [:province, :city]
	    remove_index :phones, [:province, :city]
  	end
  end
end
