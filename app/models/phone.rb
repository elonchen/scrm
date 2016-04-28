#enconding: utf-8
class Phone < ActiveRecord::Base

  belongs_to :owner, polymorphic: true

  validates :number, presence: true
  validates_uniqueness_of :number, scope: :owner_type

  before_validation :trim
  after_save :fix_phone_address, if: :number_changed?



  def fix_phone_address
    begin
      PhoneAddress.get(number) do |address|
        self.update_columns(
          :province => address[:province],
          :city => address[:city],
          :areacode => address[:areacode],
          :zip => address[:zip],
          :company => address[:company],
          :card => address[:card],
          )
        if (self.owner.is_a? Customer) && self.owner.province.blank?
          self.owner.update_columns(
            :province => address[:province],
            :city => address[:city]
            )
        end
      end
    rescue => e
      logger.error e
    end
  end
  private
  def trim
    self.number = self.number.gsub(' ', '') if self.number
  end
end
