class EducationHistory < ActiveRecord::Base
  delegate :user, :to=> :user, :allow_nil=>false
  belongs_to :resume
  validates :school_name, :from, :until, :education, presence: true
  resourcify
end
