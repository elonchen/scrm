class Faq < ActiveRecord::Base
  validates_presence_of :title, :question
  belongs_to :member
  default_scope {order("created_at DESC")}
end
