json.array!(@zones) do |zone|
  json.extract! zone, :id, :name, :zone_type, :parent_zone_id
  json.url zone_url(zone, format: :json)
end
