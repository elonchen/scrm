# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
department = Department.create!(:name => "研发部")
Member.create!(:email=>"admin@isumeng.com", :password=>"adminadmin", :"name"=>"admin", :bank_card_type =>"支付宝", :department => department)
m = Member.first
m.confirm!
m.add_role :admin