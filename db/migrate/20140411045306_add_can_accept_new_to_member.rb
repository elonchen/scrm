class AddCanAcceptNewToMember < ActiveRecord::Migration
  def change
    add_column :members, :can_accept_new, :boolean, default: true
  end
end
