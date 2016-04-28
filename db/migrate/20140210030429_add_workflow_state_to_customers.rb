class AddWorkflowStateToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :workflow_state, :string
  end
end
