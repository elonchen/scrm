json.array!(@navigations) do |navigation|
  json.extract! navigation, :id, :name, :link
  json.url navigation_url(navigation, format: :json)
end
