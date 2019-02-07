# frozen_string_literal: true

class Organization < ApplicationRecord
  include AASM

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :ownerships, as: :ownable
  has_many :created_courses, through: :ownerships, source: :course

  validates :name, presence: true, length: { in: 2..20 }
  validates :description, length: { maximum: 500 }

  aasm :column => 'state' do
    state :unverified, initial: true
    state :verified
    state :rejected
    state :archived

    event :verify do
      transitions from: [:unverified], to: :verified
    end
    event :reject do
      transitions from: [:unverified], to: :rejected
    end
    event :reverify do
      transitions from: [:verified], to: :unverified
    end
    event :archive do
      transitions from: [:verified, :unverified], to: :archived
    end
  end
end
