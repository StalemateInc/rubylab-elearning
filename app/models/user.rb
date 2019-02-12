# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_one :profile, dependent: :destroy
  has_many :ownerships, as: :ownable
  has_many :created_courses, through: :ownerships, source: :course
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :participations, dependent: :destroy
  has_many :enrolled_courses, through: :participations, source: :course
  has_many :join_requests, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :completion_records
  has_many :certificates, through: :completion_records
  has_many :user_answers, dependent: :destroy
  has_many :course_accesses, dependent: :destroy
  has_many :allowed_courses, through: :course_accesses, source: :course
  has_many :favorite_courses, dependent: :destroy
  has_many :impersonation_histories, class_name: 'ImpersonationHistory', foreign_key: :impersonator_id

  accepts_nested_attributes_for :profile

  def password_match?
    self.errors[:password] << I18n.t('errors.messages.blank') if password.blank?
    self.errors[:password_confirmation] << I18n.t('errors.messages.blank') if password_confirmation.blank?
    self.errors[:password_confirmation] << I18n.translate('errors.messages.confirmation', attribute: 'password') if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  # new function to set the password without knowing the current
  # password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # new function to provide access to protected method unless_confirmed
  def only_if_unconfirmed
    pending_any_confirmation { yield }
  end

  def password_required?
    # Password is required if it is being set, but not for new records
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end
end
