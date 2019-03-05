# frozen_string_literal: true

class Course < ApplicationRecord
  mount_uploader :image, CourseImageUploader

  has_one :ownership, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :students, through: :participations, source: :user
  has_many :certificates, dependent: :destroy
  has_many :pages, dependent: :destroy
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

  def self.accessible_organizations_courses(user)
    where(ownership: Ownership.where(ownable: user.organizations), visibility: [:organization, :everyone])
  end

  def self.accessible_user_courses(user)
    where(ownership: Ownership.where(ownable_type: 'User'), visibility: :everyone)
        .union(user.allowed_courses.where(ownership: Ownership.where(ownable_type: 'User')))
  end

  def self.recommended_courses(user)
    where.not(id: user.completed_courses).where.not(id: user.enrolled_courses).order('rating DESC')
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

  def favorited_by?(user)
    in?(user.favorites)
  end
end
