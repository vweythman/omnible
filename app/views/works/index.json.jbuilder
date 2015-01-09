json.array!(@works) do |work|
  json.extract! work, :title, :user_id
  json.url work_url(work, format: :json)
end