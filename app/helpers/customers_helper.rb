module CustomersHelper
  def workflow_state_name(state)
    I18n.t "customer.workflow_state.#{state}"
  end
end
