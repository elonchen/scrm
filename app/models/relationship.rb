class Relationship < ActiveRecord::Base
  belongs_to :manager, class_name: "Member"
  belongs_to :worker, class_name: "Member"
  validates :manager_id, presence: true
  validates :worker_id, presence: true
end
