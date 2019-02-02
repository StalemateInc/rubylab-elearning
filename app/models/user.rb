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
  has_many :feedbacks

  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new function to return whether a password has been set
  def has_no_password?
    encrypted_password.blank?
  end

  # new function to provide access to protected method unless_confirmed
  def only_if_unconfirmed
    unless_confirmed { yield }
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
