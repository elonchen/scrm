json.extract! @customer, :id, :name, :email, :qq, :from, :vip_level, :introduction, :created_at, :updated_at
json.phones(@customer.phones) do |phone|
  json.extract! phone, :number
end
