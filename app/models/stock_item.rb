class StockItem < Item
  validates :amount, :numericality => { :less_than_or_equal_to => 0 }, :presence=>true

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
    I18n.t("stock_item.workflow_state.#{workflow_state}")
  end
end