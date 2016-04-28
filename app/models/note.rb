#encoding: utf-8
class Note < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :customer
  belongs_to :member
  
  has_many :alarms, as: :owner

  accepts_nested_attributes_for :alarms

  has_one :order
  has_many :transaction_records
  accepts_nested_attributes_for :transaction_records

  validates_presence_of :from_state, :to_state
  validates :type, presence: true, :inclusion => {:in  => %w(CommunicationNote VisitNote) }
  validate :validate_update_time, :on => :update

  default_scope -> {order("created_at DESC")}
  after_create :create_note_callback
  after_update :change_note_callback
  before_create :create_order_if_transaction_notes


  scope :of_today, -> {where(:created_at => [DateTime.now().beginning_of_day..DateTime.now])}
  scope :of_owner_id, -> (member_id) {where(:member_id => member_id)}
  scope :of_customer_id, -> (customer_id) { where(:customer_id => customer_id)}
  scope :of_communication_notes, -> {where(:type => 'CommunicationNote')}
  scope :of_visit_notes, -> {where(:type => 'VisitNote')}
  include PublicActivity::Model

  include ActionView::Helpers::NumberHelper


  %w[CommunicationNote VisitNote].each do |type_value|
    define_method "is_#{type_value.demodulize.underscore}?".to_sym do
      self.type == type_value.to_s
    end
  end


  def create_order_if_transaction_notes
    unless transaction_records.empty?
      self.create_order(:amount => transaction_records.inject(0.0){|sum, transaction_record| sum += transaction_record.amount})
    end
  end

  def validate_update_time 
    unless self.created_at > 24.hour.ago
      self.errors.add(:created_at, "创建超过24小时，不再允许更改")
    end
  end

  def create_note_callback
    self.customer.update_attributes(:last_updated_at=> DateTime.now, :last_member=>self.member)
    if event.present?
      from_state_name = self.customer.workflow_state_name(self.from_state)
      to_state_name = self.customer.workflow_state_name(self.customer.current_state.events[event.to_sym][0].transitions_to.to_s) rescue '无效状态'
      self.customer.send "#{event}!", "note.add_note", self, {
          :content=>[nil, content],
          :workflow_state=>[from_state_name, to_state_name],
          :transaction_records=>[nil, self.transaction_records.map{|record| "#{Product.human_attribute_name(:name)}:#{record.product.name}"}.join('<br/>')]

        }
      self.update_column(:to_state, self.customer.current_state.to_s)
    else
      self.create_activity :add_note, recipient: self, owner: Proc.new{ |controller, model| controller.current_member }, params: {changes: {:content=>[nil, content]}}
    end
  end

  def change_note_callback
    reason = {}
    if self.content_changed?
      reason[:content] = self.changes[:content]
    end
    self.create_activity :change_note, recipient: self, owner: Proc.new{ |controller, model| controller.current_member }, params: {changes: reason}
  end
  

end
