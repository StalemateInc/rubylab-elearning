# frozen_string_literal: true

class JoinRequest < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  enum status: %i[pending accepted rejected]
end
