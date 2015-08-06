json.array!(@education_histories) do |education_history|
  json.extract! education_history, :id, :resume_id
  json.url education_history_url(education_history, format: :json)
end
