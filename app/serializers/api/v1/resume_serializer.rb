class Api::V1::ResumeSerializer < Api::V1::BaseSerializer
  attributes :id, :name, :created_at, :updated_at

  has_many :work_histories,foreign_key: 'resume_id', class_name: 'WorkHistory', serializer: WorkHistorySerializer, embed: :object, authorize: true
  has_many :education_histories,foreign_key: 'resume_id', class_name: 'EducationHistory', serializer: EducationHistorySerializer, embed: :object, authorize: true


  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end
