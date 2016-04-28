#encoding: utf-8
class ConfigCustomer < Settingslogic
  source "#{Rails.root}/config/customer_config.yml"
  namespace Rails.env
end
