#encoding: utf-8
class MarkPool < ActiveRecord::Migration
  def change
    # 只要 5 天没联系过的，就入池
    expire_day = 5
    i = 1
    Customer.find_each {|c|
      # 最新的沟通记录在5天以前的，
      puts "正在处理第#{i}条客户记录" if i % 100 == 0
      c.update_columns(pool: true) if c.last_updated_at <= expire_day.days.ago
      i = i + 1
    }
  end
end
