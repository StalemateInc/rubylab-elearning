# frozen_string_literal: true

class Organization < ApplicationRecord
  include AASM
  enum state: [:unverified, :verified, :archived]

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :ownerships, as: :ownable, dependent: :destroy
  has_many :created_courses, through: :ownerships, source: :course
  has_many :invites, dependent: :destroy
  has_many :join_requests, dependent: :destroy

  validates :name, presence: true, length: { in: 2..100 }
  validates :description, length: { maximum: 500 }

  def org_admin_list
    memberships.where(org_admin: true).map(&:user)
  end

  aasm column: 'state' do
    state :unverified, initial: true
    state :verified
    state :archived

    event :verify do
      transitions from: [:unverified], to: :verified
    end
    event :reverify do
      transitions from: [:verified], to: :unverified
    end
    event :archive do
      transitions from: [:verified, :unverified], to: :archived
    end
  end
end
