# frozen_string_literal: true

class Organization < ApplicationRecord
  mount_uploader :image, OrganizationImageUploader
  include AASM
  include PgSearch
  searchkick word_middle: %i[name description], callbacks: :async
  enum state: [:unverified, :verified, :archived]

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :ownerships, as: :ownable, dependent: :destroy
  has_many :created_courses, through: :ownerships, source: :course
  has_many :invites, dependent: :destroy
  has_many :join_requests, dependent: :destroy

  validates :name, presence: true, length: { in: 2..100 }
  validates :description, length: { maximum: 500 }

  pg_search_scope :full_text_search, against: [:name, :description], using: { tsearch: { prefix: true } }

  def org_admin_list
    memberships.where(org_admin: true).map(&:user)
  end

  def search_data
    {
      id: id,
      class: self.class.name.downcase,
      name: name,
      description: description,
      state: state,
      members: users.pluck(:id)
    }
  end

  def as_json(options={})
    super.as_json(options).merge({class: get_class})
  end

  def get_class
    self.class.name.downcase
  end

  def self.sql_full_text_search(query, _user)
    full_text_search(query)
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

  after_commit on: [:update] do
    if ownerships = Ownership.where(ownable_type: 'Organization', ownable_id: id)
      ownerships.pluck(:course_id).each do |id|
        Course.find_by(id: id).__elasticsearch__.update_document 
      end
    end
  end

  before_destroy do
    if ownerships = Ownership.where(ownable_type: 'User', ownable_id: id)
      @ids = ownerships.ids
    end
  end
end
