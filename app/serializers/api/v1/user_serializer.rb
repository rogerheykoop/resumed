class Api::V1::UserSerializer < Api::V1::BaseSerializer
  attributes :id, :email, :created_at, :updated_at

  has_many :resumes,foreign_key: 'user_id', class_name: 'Resume', serializer: ResumeSerializer, embed: :object, authorize: true

  #has_many :work_histories, through: :resumes
  #has_many :education_histories, through: :resumes

  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end
