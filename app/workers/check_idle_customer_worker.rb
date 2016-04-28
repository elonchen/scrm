#encoding: utf-8
class CheckIdleCustomerWorker
  include Sidekiq::Worker
  MAX_IDLE_DAYS = ConfigCustomer.max_idle_days
  def perform
    Customer.find_each {|c|
      if c.last_updated_at <= MAX_IDLE_DAYS.days.ago
        puts "[#{Time.now}] put customer id:#{c.id} name:#{c.name} last_updated_at:#{c.last_updated_at} into customer pool"
        c.recycle
      end
    }
  end
end
