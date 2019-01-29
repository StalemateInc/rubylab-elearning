# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  validates :name, :surname, presence: true, length: { in: 4..20 }, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
  validates :nickname, presence: true, length: { in: 3..50 }
end
