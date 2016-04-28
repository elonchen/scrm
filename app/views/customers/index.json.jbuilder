json.array!(@customers) do |customer|
  json.extract! customer, :id, :name, :email, :qq, :from, :vip_level, :introduction
  json.url customer_url(customer, format: :json)
  json.phones(customer.phones) do |phone|
    json.extract! phone, :number
  end
end
