class Resume < ActiveRecord::Base
    belongs_to :user
    has_many :work_histories
    has_many :education_histories
    validates :name, presence: true
    resourcify
end
