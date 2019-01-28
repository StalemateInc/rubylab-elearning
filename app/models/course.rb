class Course < ApplicationRecord
  has_one :ownership, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :passers, through: :participations, source: :user

end
