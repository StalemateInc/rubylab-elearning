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
end
