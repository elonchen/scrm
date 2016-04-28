json.array!(@items) do |item|
  json.extract! item, :id, :name, :type, :amount, :saler_id, :products_id, :description, :customer_id, :ddb_account_id, :time_gap, :applier_id, :approver_id
  json.url item_url(item, format: :json)
end
