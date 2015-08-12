class WorkHistory < ActiveRecord::Base
    delegate :user, :to=> :user, :allow_nil=>false
    belongs_to :resume
    validates :company_name, :from, :until, :position, presence: true
    resourcify
end
