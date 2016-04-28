json.array!(@ddb_accounts) do |ddb_account|
  json.extract! ddb_account, :id, :name, :customer_id, :email, :slug, :title, :member_id
  json.url ddb_account_url(ddb_account, format: :json)
end
