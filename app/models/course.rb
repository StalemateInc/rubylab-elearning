# frozen_string_literal: true

class Course < ApplicationRecord

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
  enum visibility: %i[everyone organizations individuals]
  enum status: %i[drafted published archived]

  validates :name, presence: true, length: { in: 4..20 }
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :difficulty, presence: true, inclusion: { in: difficulties.keys }
  validates :description, length: { maximum: 500 }
  validate :check_visibility_and_owner

  def owner
    owner_record = ownership
    owner_record.nil? ? owner_record : owner_record.ownable
  end

  def check_visibility_and_owner
    if !owner.instance_of?(Organization) && organizations?
      errors.add(:visibility, "Can't be created only for organizations if the user is not an organization admin.")
    end
  end
end
