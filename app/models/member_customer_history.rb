#encoding: utf-8

#
# 只要系统回收了该客户，就会进入这里
#
class MemberCustomerHistory < ActiveRecord::Base
  belongs_to :member
  belongs_to :customer

  validates_presence_of :member, :customer, :last_state, :last_updated_at
  validates :last_state, :inclusion => {:in => Customer.workflow_spec.states.keys.map(&:to_s)}
end