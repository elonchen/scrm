#encoding: utf-8
class ItemMailer < ActionMailer::Base
  add_template_helper(ItemsHelper)
  def item_mailer(item, applier_email = nil)
    @item = item
    @url  = item_url(item)
    if item.is_sale_item?
      @subject = "今日收款+#{item.name}"
    elsif item.is_stock_item?
      @subject = "今日采购+#{item.name}"
    end

    begin
      to = []
      to << SystemConfig.where(:key=>"accouting_email").first_or_create(:key=>"accouting_email", :value=>"xie_s@isumeng.com").value

      to << "#{applier_email}" if applier_email.present? and !to.include?(applier_email)

      # 测试用，勿删
      # if Rails.env.development?
      #   @subject = '【测试】' + @subject
      #   to = "ma_w@isumeng.com"
      # end

      mail(to: to, subject: @subject) do |format|
        format.html { render text: "<p>交易名称：#{item.name}</p><p>流水状态：#{item.workflow_state_name}</p><p>交易详情：<a href=\"#{item.show_url}\">点击这里查看详情</a></p>" }
      end
    rescue => e
      logger.error e.message
    end
  end
end
