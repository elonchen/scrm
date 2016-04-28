class TransactionRecord < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :product
  belongs_to :member
  belongs_to :customer
  belongs_to :note
  belongs_to :saler, :class_name => "Member"
  has_one :order, :through=>:note
  default_scope -> {order("created_at DESC")}

  validates :note, :saler, :member, :product, :customer, :presence=>true
end
