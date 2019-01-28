class Organization < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :ownerships, as: :ownable
  has_many :created_courses, through: :ownerships, source: :course

end
