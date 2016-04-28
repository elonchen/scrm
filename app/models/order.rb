class Order < ActiveRecord::Base
  belongs_to :note
  validates :note, :presence=>true
  before_validation :before_validation_callback
  has_many :transaction_records, through: :note
  has_many :sale_items

  default_scope -> {order("created_at DESC")}
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_member }

  include Workflow

  workflow do
    state :new do
      event :close, :transitions_to => :closed
    end
    state :closed
  end

  def close
    self.create_activity :close, owner: Proc.new{ |controller, model| controller.current_member }
  end

  def workflow_state_name
    I18n.t("order.workflow_state.#{self.current_state}")
  end

  def has_pay_all?
    self.amount <= sale_items.with_accepted_state.inject(0){|sum, sale_item| sum += sale_item.amount}
  end

  def money_not_paid
    self.amount - sale_items.with_accepted_state.inject(0){|sum, sale_item| sum += sale_item.amount}
  end

  private

  def before_validation_callback
    self.human_order_id = Time.now.strftime("%Y%m%d%H%M%S%L")
  end

end
