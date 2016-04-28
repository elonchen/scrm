# encoding : utf-8
class PhoneValidator < ActiveModel::EachValidator
  REGEXP = /\A0?1\d{10}\Z/i
  def validate_each(record, attribute, value)
    unless value =~ REGEXP
      record.errors[attribute] << (options[:message] || "格式错误")
    end
  end
end