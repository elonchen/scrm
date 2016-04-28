#encoding: utf-8
module ItemsHelper
  def sti_item_path(type="Item", item=nil, action=nil)
    send "#{format_sti_item(action, type, item)}_path", item
  end


  def format_sti_item(action, type, item)
    action || item ? "#{format_item_action(action)}#{type.underscore}" :
     "#{type.underscore.pluralize}"
  end

  def format_item_action(action)
    action ? "#{action}_" : ""
  end

  def item_type_name(item)
    if item.is_sale_item?
      "收入"
    else
      "支出"
    end
  end

  def expired_due_items_need_to_request
    #需要催款的尾款

    unless current_member.has_role? :admin
      sale_items = SaleItem.with_accepted_state.where(:applier => current_member, :has_balance_due=> true, :due_item_id=>nil)
    else
      sale_items = SaleItem.with_accepted_state.where(:has_balance_due=> true, :due_item_id=>nil)
    end
    sale_items.select{|sale_item| sale_item.due_date < Time.now }
  end
end
