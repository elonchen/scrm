json.array!(@departments) do |department|
  json.extract! department, :id, :name, :members_count
  json.url department_url(department, format: :json)
end
