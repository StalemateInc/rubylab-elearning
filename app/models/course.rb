# frozen_string_literal: true

class Course < ApplicationRecord
  include PgSearch
  searchkick word_middle: %i[name description text_owner], callbacks: :async
  mount_uploader :image, CourseImageUploader

  has_one :ownership, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :students, through: :participations, source: :user
  has_many :certificates, dependent: :destroy
  has_many :pages, dependent: :destroy
  has_many :questions, through: :pages
  has_many :completion_records, dependent: :destroy
  has_many :favorite_courses, dependent: :destroy
  has_many :user_answers, dependent: :destroy
  has_many :course_accesses, dependent: :destroy
  has_many :allowed_users, through: :course_accesses, source: :user

  enum difficulty: %i[unspecified novice intermediate advanced professional]
  enum visibility: %i[everyone organization individuals]
  enum status: %i[drafted published archived]

  validates :name, presence: true, length: { in: 4..20 }
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :difficulty, presence: true, inclusion: { in: difficulties.keys }
  validates :description, length: { maximum: 500 }
  validate :check_visibility_and_owner

  scope :search_import, -> { includes(:course_accesses) }
  pg_search_scope :full_text_search, against: %i[name description], using: { tsearch: { prefix: true } }

  def search_data
    {
      id: id,
      class: self.class.name.downcase,
      name: name,
      description: description,
      difficulty: difficulty,
      status: status,
      visibility: visibility,
      accessed_by: accessible_by,
      text_owner: text_owner,
      exact_owner: search_owner,
      members: students.pluck(:id)
    }
  end

  def as_json(options={})
    super.as_json(options).merge({class: get_class})
  end

  def get_class
    self.class.name.downcase
  end

  def self.sql_full_text_search(query, user)
    organizations_private_courses = Course.where(ownership: Ownership.where(ownable: user.organizations), visibility: :organization)
    public_courses = Course.where(visibility: :everyone)
    allowed_courses = user.allowed_courses
    ultimate_query = organizations_private_courses.union(public_courses).union(allowed_courses)
    ultimate_query.full_text_search(query)
  end

  def owner
    owner_record = ownership
    owner_record.nil? ? owner_record : owner_record.ownable
  end

  def check_visibility_and_owner
    if !owner.instance_of?(Organization) && organization?
      errors.add(:visibility, "Can't be created only for organizations if the user is not an organization admin.")
    end
  end

  def owner?(user)
    if owner.instance_of?(User)
      owner == user
    else
      user.in?(owner.org_admin_list)
    end
  end

  private

  def text_owner
    owned_by = owner
    if owned_by.instance_of?(Organization)
      owned_by.name
    else
      profile = owned_by.profile
      "#{profile.name} #{profile.nickname} #{profile.surname}"
    end
  end

  def accessible_by
    if organization?
      owner.users.pluck(:id)
    else
      course_accesses.pluck(:user_id)
    end
  end

  def search_owner
    owned_by = owner
    "#{owned_by.class.name}__#{owned_by.id}"
  end

  def favorited_by?(user)
    in?(user.favorites)
  end

end
