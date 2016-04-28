class VisitNote < Note 
	has_one :person
	accepts_nested_attributes_for :person

	validates :person, :visit_at, presence: true
	validates :visit_reason, presence: true, length: {minimum: 20}

  	validates :content, presence: true, length: {minimum: 20}, on: :update

  	validate :validate_visit_at


  	def validate_visit_at
  		if self.visit_at < Time.now
  			self.errors.add(:visit_at, "填写错误，为避免篡改和恶意录入，拜访记录必须提前录入。")
  		end
  	end

end