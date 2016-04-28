class SaleItem < Item
  belongs_to :ddb_account
  belongs_to :order
  belongs_to :partner, class_name: 'Member'
  belongs_to :bank_account
  validates :amount, :presence=>true, :numericality => { :greater_than_or_equal_to => 0 }
  validates_presence_of :time_gap, :order, :bank_account
  validates :balance_due, :presence=>true, :numericality => {:greater_than_or_equal_to => 0}, if: :has_balance_due
  validates :due_date, presence: true, if: :has_balance_due
  belongs_to :due_item, class_name: "SaleItem"

  def cancel
  end

  def accept(member)
    self.update_attribute(:approver, member)
    super
  end

  def reject(member, reason = nil)
    self.update_attribute(:approver, member)
    super
  end

  def workflow_state_name
    I18n.t("sale_item.workflow_state.#{workflow_state}")
  end
end