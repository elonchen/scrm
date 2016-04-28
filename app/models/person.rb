class Person < ActiveRecord::Base
  belongs_to :visit_note
  validates :name, :pos, presence: true
  validates :phone, phone: true

  validate :check_phone_wechat_number


  private
  def check_phone_wechat_number 
  	if self.phone.blank? && self.wechat_number.blank?
  		self.errors.add(:base, "手机和微信号必须至少填写一项")
  	end
  end

end
