#encoding: utf-8

require 'active_support/concern'

module CustomerImporter extend ActiveSupport::Concern
  included do

  end

  module ClassMethods
    def import_from_csv(member, file)
      rows = get_rows_from_csv_file(file)
      result = {
          success_count: 0,
          fail_count: 0,
          fail_customer_errors: []
      }
      rows.each_with_index do |r, i|
        Customer.transaction do
          customer = Customer.new(
              name: r[0],
              qq: r[2],
              email: r[3],
              from: r[4],
              introduction: r[5],
              is_agent: false,
              member: member,
              last_member: member
          )
          if customer.save
            phone = customer.phones.new(number: r[1])
            if phone.save
              result[:success_count] = result[:success_count] + 1
            else
              result[:fail_count] = result[:fail_count] + 1
              result[:fail_customer_errors] << {
                  line: i,
                  error: phone.errors
              }
            end
          else
            result[:fail_count] = result[:fail_count] + 1
            result[:fail_customer_errors] << {
                line: i,
                error: customer.errors
            }
          end
        end
      end
      result
    end

    private
    def get_rows_from_csv_file(file)
      begin
        csv = CSV.parse(File.open(file.path, 'r:gb18030:utf-8') { |f| f.read }, col_sep: ",")
      rescue => e
        csv = CSV.parse(File.open(file.path, 'r:utf-8') { |f| f.read }, col_sep: ",")
      end
      validate_csv_header(csv.first)
      # 去掉第一行
      csv.shift
      rows = []
      csv.each{|row| rows << row if row[0].present? }
      rows
    end

    FILE_HEADER = %W[
        姓名
        电话
        QQ
        邮箱
        来源
        简介
  ]
    def validate_csv_header(header)
      if header != FILE_HEADER
        raise "文件头格式错误!"
      end
    end
  end
end