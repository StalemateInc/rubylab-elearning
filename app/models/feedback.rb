# frozen_string_literal: true

class Feedback < ApplicationRecord
  belongs_to :course
  belongs_to :user

  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :content, presence: true, length: { maximum: 200 }
end
