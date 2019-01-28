class Organization < ApplicationRecord
  has_many :courses, :as => :ownable
end
