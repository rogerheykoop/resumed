class Resume < ActiveRecord::Base
    belongs_to :user
    resourcify
end
