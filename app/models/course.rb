class Course < ApplicationRecord
  has_one :ownership, dependent: :destroy
  has_many :participations, dependent: :destroy

end
