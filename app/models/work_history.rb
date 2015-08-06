class WorkHistory < ActiveRecord::Base
    delegate :user, :to=> :user, :allow_nil=>false
    belongs_to :resume
    resourcify
end
