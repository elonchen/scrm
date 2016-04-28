class AddTypeToNote < ActiveRecord::Migration
  def up
  	unless column_exists? :notes, :type
    	add_column :notes, :type, :string
    end
    Note.update_all(:type => 'CommunicationNote')
  end

  def down
  	remove_column :notes, :type
  end
end
