# frozen_string_literal: true

class Course < ApplicationRecord
  has_one :ownership, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :passers, through: :participations, source: :user
  has_many :feedbacks

  validates :name, presence: true, length: { in: 4..20 }
  validates :duration, :views, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
