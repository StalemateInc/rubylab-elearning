# frozen_string_literal: true

class Profile < ApplicationRecord
  mount_uploader :image, ProfileImageUploader

  belongs_to :user
  validates :name, :surname, presence: true, length: { in: 2..35 },
                             format: { with: /\A[a-zA-Z]+\z/, message: 'only allows letters' }
  validates :nickname, presence: true, length: { in: 3..50 }
  validates_uniqueness_of :user_id
  validates_uniqueness_of :nickname

  after_commit on: [:update] do
    if ownerships = Ownership.where(ownable_type: 'User', ownable_id: self.user_id)
      ownerships.pluck(:course_id).each do |id|
        Course.find_by(id: id).__elasticsearch__.update_document 
      end
    end
  end
end
