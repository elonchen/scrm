#encoding: utf-8
class Item < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :applier, class_name: "Member"
  belongs_to :approver, class_name: "Member"
  belongs_to :department, counter_cache: :items_count
  validates :name, :description, :department, :presence=>true
  validates :applier, :presence=>true
  validates :type, :inclusion=> { :in => ["SaleItem", "StockItem"] }
  
  default_scope -> {order("FIELD(workflow_state, 'new', 'accepted', 'rejected', 'canceled')").order("created_at DESC")}
  scope :owner_of_, ->(member){ where(:applier => member) unless member.has_role? :admin }
  scope :owner_or_partner_of, ->(member){
    where('applier_id = :owner_id or partner_id = :partner_id', {
      owner_id: member.id, partner_id: member.id
    }) unless member.has_role? :admin
  }
  scope :applied_by, ->(member){ where(:applier => member)}
  scope :with_month, ->(month_time){
    where("transaction_time >= ? and transaction_time <= ? ", month_time.beginning_of_month, month_time.end_of_month) if month_time.present?
  }

  scope :of_sale_items, ->{where(:type=>'SaleItem')}
  scope :of_stock_items, ->{where(:type=>'StockItem')}

  before_validation :set_department_id, on: :create
  
  include Workflow

  workflow do
    state :new do
      event :accept, :transitions_to => :accepted
      event :cancel, :transitions_to => :canceled
      event :reject, :transitions_to => :rejected
      after_transition do |*args|
        self.reload # confirm state changed
        if [:accepted, :rejected].include? self.workflow_state.to_sym
          ItemMailer.item_mailer(self, self.applier.email).deliver
        end
      end
    end
    state :accepted
    state :rejected
    state :canceled
  end

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_member }

  def is_sale_item?
    self.type == "SaleItem"
  end

  def is_stock_item?
    self.type == "StockItem"
  end

  def type_name
    if is_sale_item?
      "收入"
    elsif is_stock_item?
      "支出"
    else
      "未知"
    end
  end

  def accept(member)
    ItemMailer.accept_item_mailer(self, self.applier.email).deliver
  end

  def self.to_csv(items, options)
    CSV.generate(options) do |csv|
      csv << [ "交易名称", "交易类型", "交易金额", "收款产品", "收款账户", "创建时间", "合作同事", "交易时间(不准确)", "经办人", "审批人", "描述"]
      items.each do |item|
        product_names = item.order.note.transaction_records.map{|record| record.product.name}.join("|") rescue "空"
        csv << [item.name,
          item.type_name,
          item.amount.to_s,
          product_names,
          item.is_sale_item? ? (item.bank_account.name rescue '已删除银行账户') : "",
          item.created_at.localtime.strftime("%Y-%m-%d"),
          item.try(:partner).try(:name)||"",
          item.transaction_time.localtime.strftime("%Y-%m-%d"),
          item.applier.name,
          item.approver.name,
          item.description]
      end
      sale_items = items.of_sale_items
      stock_items = items.of_stock_items
      csv << ["", "收入合计", sale_items.sum(:amount).to_s]
      csv << ["", "支出合计", stock_items.sum(:amount).to_s]
    end
  end

  def self.import(applier, filename, content)
    puts content
    content = Iconv.conv('UTF-8', 'UTF-8', content)
    path = "#{Dir.tmpdir}/#{filename}.tmp#{rand(1000)}"
    open(path, 'w:UTF-8',) do |file|
      file.write(content)
    end
    open(path, 'r:utf-8') do |file|
      spreadsheet = open_spreadsheet(filename, file)
      header = spreadsheet.row(1)
      Item.transaction do
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          puts row
          item = new(row)
          # item = new
          # row.each { |k,v| item.send("#{k}=", v)}
          item.applier = applier
          item.save!
        end
      end
    end
  end

  def self.open_spreadsheet(filename, file)
    case File.extname(filename)
      when ".csv" then Roo::CSV.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{filename}"
    end
  end

  def accept(member)
  end

  def reject(member, reason = nil)
    self.update_columns(reason: reason)
  end

  def show_url
    Rails.application.routes.url_helpers.send("#{self.type.underscore}_url", self, :host => Rails.application.config.action_mailer.default_url_options[:host])
  end

  def set_department_id 
    self.department_id = self.applier.department_id
  end

end
