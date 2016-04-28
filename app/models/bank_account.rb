class BankAccount < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :owner, :class_name=>"Member"
  has_many :sale_items
  validates_presence_of :owner, :name

  def select_json
    {id: id ,name: name}
  end

end
