class Product < ActiveRecord::Base
  validates :name, presence: true
  acts_as_paranoid
  has_many :transaction_records
end
