class Organization < ApplicationRecord
  has_many :created_courses, :as => :ownable
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

end
