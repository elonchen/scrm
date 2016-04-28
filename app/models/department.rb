class Department < ActiveRecord::Base
	has_many :members
	has_many :items
end
