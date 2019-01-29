# frozen_string_literal: true

class Membership < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :organization_id
end
