class Api::V1::WorkHistorySerializer < Api::V1::BaseSerializer
  attributes :id, :position,:from,:until,:company_name, :created_at, :updated_at

  def from
    object.from.in_time_zone.iso8601 if object.from
  end

  def until
    object.until.in_time_zone.iso8601 if object.until
  end

  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end
