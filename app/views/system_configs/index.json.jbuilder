json.array!(@system_configs) do |system_config|
  json.extract! system_config, :id, :key, :value
  json.url system_config_url(system_config, format: :json)
end
