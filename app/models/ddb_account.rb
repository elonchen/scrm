class DdbAccount < ActiveRecord::Base
  has_paper_trail
  acts_as_paranoid
  default_scope -> {order("created_at DESC")}
  belongs_to :customer
  belongs_to :member
  belongs_to :zone
  validates_presence_of :name, :customer, :email, :slug, :title, :member
  validates_uniqueness_of :slug
  validates :email, format: {with: VALID_EMAIL_ADDRESS_REGEX }

  def select_json
    {id: id , name: name}
  end

end
