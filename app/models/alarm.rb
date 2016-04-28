class Alarm < ActiveRecord::Base

  belongs_to :member
  belongs_to :owner, polymorphic: true
  before_validation :set_from_owner
  validates_presence_of :description, :time, :member_id

  scope :open, ->{ where('ahead < ?', Time.now).with_new_state }

  include Workflow
  workflow_column :state
  workflow do
    state :new do
      event :do_close, :transitions_to => :close
      event :do_timeout, :transitions_to => :timeout
    end
    state :timeout do
    end
    state :close do
    end
  end

  after_initialize do
    self.ahead = 1.days.ago unless self.ahead.present?
  end

  def do_close
    
  end

  def do_timeout

  end

  def link
    if self.owner_type == 'Note'
      Rails.application.routes.url_helpers.customer_path(owner.customer)
    end
  end

  private
  def set_from_owner
    if !self.member.present? and owner.respond_to? :member
      self.member = owner.member
    end
    true
  end

end