json.array!(@work_histories) do |work_history|
  json.extract! work_history, :id, :resume_id
  json.url work_history_url(work_history, format: :json)
end
