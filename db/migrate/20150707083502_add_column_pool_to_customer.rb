#encoding: utf-8
class AddColumnPoolToCustomer < ActiveRecord::Migration
  def change
    unless column_exists? :customers, :pool
      add_column :customers, :pool, :boolean, default: false
    end
  end
end

