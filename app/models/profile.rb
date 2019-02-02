# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  validates :name, :surname, presence: true, length: { in: 2..35 },
                             format: { with: /\A[a-zA-Z]+\z/, message: 'only allows letters' }
  validates :nickname, presence: true, length: { in: 3..50 }
  validates_uniqueness_of :user_id
end
