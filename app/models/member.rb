class Member < ActiveRecord::Base
  rolify
  acts_as_paranoid
  has_many :customers
  has_many :bank_accounts, :foreign_key=>"owner_id"
  has_many :ddb_accounts
  has_many :transaction_records
  scope :of_normal, -> {where(:is_blocked=>false)}
  scope :of_quit, -> {where(:is_blocked=>true)}
  has_many :sale_records, :class_name => "TransactionRecord", :foreign_key => "saler_id"
  has_many :notes
  has_many :sale_items, :foreign_key => "saler_id"
  belongs_to :department, counter_cache: true

  BANK_CARD_TYPES = ["支付宝", "中国农业银行", "中国工商银行", "中国建设银行", "浦发银行", "中国银行", "中国民生银行", "交通银行", "中信银行", "兴业银行", "其他"]
  validates :bank_card_type, :inclusion=> { :in => BANK_CARD_TYPES }

  has_many :member_customer_histories
  has_many :history_customers, class_name: 'Customer', through: :member_customer_histories, source: :customer
  has_many :alarms

  validates :name, :department, presence: true

  scope :can_accept_new_customers, ->{where(:can_accept_new=>true, :is_blocked=>false)}
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
  after_create :add_role_callback

  def is_admin?
    self.has_role? :admin
  end

  def in_customer_share_threshold?
    my_customer_count = self.customers.count.to_f rescue 0.0
    all_customer_count = Customer.count.to_f
    if all_customer_count == 0
      all_customer_count = 1
    end
    percentage = my_customer_count/all_customer_count
    self.customer_share_threshold >= percentage
  end

  def self.find_member_in_customer_share_threshold(member)
    Member.can_accept_new_customers.shuffle(random:srand).select{|m| (m != member)&&m.in_customer_share_threshold?}[0]
  end

  private
  def add_role_callback
    self.add_role :worker
  end
end
