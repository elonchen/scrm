class Zone < ActiveRecord::Base
  has_and_belongs_to_many :agents, class_name: 'Customer'
  has_many :ddb_accounts
  belongs_to :parent_zone, class_name: 'Zone'
  has_many :zones, :foreign_key=>"parent_zone_id"

  validates_presence_of :zone_type, :name
  validates_uniqueness_of :name, :scope=>"zone_type"
  validates :zone_type, :inclusion => {:in => %w(province capital city town)}

  def zone_type_name
    I18n.t "zone.zone_type.#{zone_type}"
  end
end
