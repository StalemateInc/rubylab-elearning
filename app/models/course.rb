# frozen_string_literal: true

class Course < ApplicationRecord

  has_one :ownership, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :students, through: :participations, source: :user
  has_many :feedbacks

  validates :name, presence: true, length: { in: 4..20 }
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :views, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def owner
    owner_record = self.ownership
    owner_record.nil? ? owner_record : owner_record.ownable
  end

end
