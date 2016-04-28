#encoding: utf-8
class Customer < ActiveRecord::Base
  include CustomerImporter
  has_paper_trail
  acts_as_paranoid
  default_scope -> {order("updated_at DESC")}

  AGENT_TYPE_EXCLUSIVE = "exclusive_agent"
  AGENT_TYPE_AGENT = "agent"

  include PublicActivity::Model
  tracked except: :update, owner: Proc.new{ |controller, model| controller.current_member }
  has_many :notes
  has_many :transaction_records
  belongs_to :last_member, class_name: "Member"
  has_and_belongs_to_many :zones
  has_many :member_customer_histories
  has_many :history_members, class_name: Member, through: :member_customer_histories, source: :member

  accepts_nested_attributes_for :notes



  scope :exclusive_agent, ->{where(:is_agent=>true, :agent_type=>AGENT_TYPE_EXCLUSIVE)}
  scope :normal_agent, ->{where(:is_agent=>true, :agent_type=>AGENT_TYPE_AGENT)}
  before_validation :auto_update

  after_update :change_customer

  validates_uniqueness_of :email, :qq, :allow_blank=>true
  validates_presence_of :introduction, :last_member, :last_updated_at
  validates :from, presence: true, :inclusion => {:in => ConfigCustomer.from.keys.map(&:to_s)}, on: :create
  validates_presence_of :agent_type, if: :is_agent
  validates :agent_type, :inclusion => {:in => %w(agent exclusive_agent)}, if: :is_agent
  validates :vip_level, presence: true, :inclusion => {:in => %w(potential normal important)}
  validates :shop_type, :inclusion => {:in => %w(single service chain multiple agent)}, if: :shop_type
  validates :level, :numericality=> {:greater_than => 0, :less_than_or_equal_to => 100}, :allow_blank => true
  has_many :phones, as: :owner, inverse_of: :owner
  accepts_nested_attributes_for :phones, :allow_destroy => true

  belongs_to :member, counter_cache:true
  scope :managed_by, ->(member_id){ where(:last_member_id=>member_id)}
  scope :in_pool, ->{where(pool: true)}
  scope :need_to_contact_for, ->(member){
    Customer
    .where(:workflow_state=>[:new, :contacting, :free_trial])
    .where("(last_member_id = #{member.id} AND last_updated_at < DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 3 DAY)) OR (last_member_id != #{member.id} AND last_updated_at < DATE_SUB(CURRENT_TIMESTAMP, INTERVAL #{ConfigCustomer::max_idle_days} DAY) AND historical_rejects < 3 )")
    .order(last_updated_at: :desc)
  }

  include Workflow

  workflow do
    state :new do
      event :contact, :transitions_to => :contacting
      event :reject, :transitions_to => :rejected
      event :apply_free_trial, :transitions_to => :free_trial
    end
    state :contacting do
      event :apply_free_trial, :transitions_to => :free_trial
      event :reject, :transitions_to => :rejected
      event :pay, :transitions_to => :accepted
      event :renew, :transitions_to => :new
    end
    state :free_trial do
      event :pay, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
      event :renew, :transitions_to => :new
    end
    state :accepted do
      event :apply_free_trial, :transitions_to => :free_trial
      event :renew, :transitions_to => :new
      event :pay, :transitions_to => :accepted
    end

    state :rejected do
      event :apply_free_trial, :transitions_to => :free_trial
      event :contact, :transitions_to => :contacting
      event :renew, :transitions_to => :new
    end
  end

  def managable_by(member)
    self.last_member == member or self.in_pool?
  end

  def can_manage_by(member)
    #
    # 当前接管中
    # 别人放弃的、在公共池中的、长久没联系的
    #
    self.last_member == member or self.rejected? or self.in_pool? or self.last_updated_at < ConfigCustomer::max_idle_days.days.ago
  end

  def change_customer
    reason = self.changes
    reason.delete :updated_at
    self.create_activity :update, owner: Proc.new{ |controller, model| controller.try(:current_member) }, params: {changes: reason}
  end

  def agent_type_name
    I18n.t("customer.agent_type.#{agent_type}")
  end

  def renew(action, recipient, changes)
    self.create_activity key: action, recipient: recipient, owner: Proc.new{ |controller, model| controller.current_member }, params: {changes: changes}
  end

  def contact(action, recipient, changes)
    self.create_activity key: action, recipient: recipient, owner: Proc.new{ |controller, model| controller.current_member }, params: {changes: changes}
  end

  def apply_free_trial(action, recipient,changes)
    self.create_activity key: action, recipient: recipient, owner: Proc.new{ |controller, model| controller.current_member }, params: {changes: changes}
  end

  def pay(action, recipient, changes)
    self.create_activity key: action, recipient: recipient, owner: Proc.new{ |controller, model| controller.current_member }, params: {changes: changes}
  end

  def reject(action, recipient, changes)
    self.create_activity key: action, recipient: recipient, owner: Proc.new{ |controller, model| controller.current_member }, params: {changes: changes}
  end

  def workflow_state_name(state = nil)
    I18n.t "customer.workflow_state.#{state||workflow_state}"
  end

  def in_pool?
    pool == true
  end

  #
  # 回收客户资源
  #
  def recycle
    self.update!(pool: true)
    #
    # 如果客户状态是拒绝，除非已经被3个销售拒绝，否则强制更新其状态为新
    #
    if self.workflow_state == 'rejected'
      rejects = self.member_customer_histories.where(last_state: 'rejected')
      unless rejects.present? and rejects.count >= 3
        self.update_column(:workflow_state, 'new')
        self.reload
      end
    end
  end

  # 被3个不同销售放弃的客户，认为是不需要再联系
  def need_to_contact?
    rejects = self.member_customer_histories.where(last_state: 'rejected')
    !rejects.present? or rejects.count < 3
  end

  def create_or_update_history(member_id, last_state, last_updated_at)
    history = self.member_customer_histories.find_by(member_id: member_id)
    if history.present?
      history.update!(last_state: last_state, last_updated_at: last_updated_at)
    else
      unless self.new_record?   # 如果是新记录，无需要创建历史
        self.member_customer_histories.create!(member_id: member_id, last_state: last_state, last_updated_at: last_updated_at)
      end
    end
  end

  # 有放弃记录，且当前状态是可领取
  def hide_reject_record?
    self.need_to_contact? and self.workflow_state == 'new'
  end

  # def phone_numbers_with_legacy
  #   (self.phones.map(&:number) + [self.tel]).compact.uniq
  # end

  def select_json
    {id: id , name: name}
  end

  private
  def auto_update
    # 初始化
    if last_updated_at.nil?
      self.last_updated_at = DateTime.now
    end
    if last_member.nil?
      self.last_member = member
    end

    # 如果以下值变更了，获取变更前的值，以作历史记录
    h_member_id = self.last_member_id_changed? ? self.last_member_id_was : self.last_member_id
    h_state = self.workflow_state_changed? ? self.workflow_state_was : self.workflow_state
    h_updated_at = self.last_updated_at_changed? ? self.last_updated_at_was : self.last_updated_at

    #
    # 接管销售变更，需要更新时间及历史
    #
    if self.last_member_id_changed?
      self.create_or_update_history(h_member_id, h_state, h_updated_at) unless self.in_pool?  # 如果已经在公共池中，说明历史已经记录了
      self.pool = false
      self.last_updated_at = DateTime.now
    end

    if self.last_updated_at_changed?
      self.pool = false
    end

    # 进入公共池，需要创建历史
    if self.pool_changed? and self.pool == true
      self.create_or_update_history(h_member_id, h_state, h_updated_at)
    end

    # 更新历史拒绝数（被不同销售拒绝的数量）
    self.historical_rejects = self.member_customer_histories.where(last_state: 'rejected').uniq(:member_id).count

    true
  end

end
