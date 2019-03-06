# frozen_string_literal: true

class Participation < ApplicationRecord
  belongs_to :course
  belongs_to :user
  belongs_to :page, optional: true

  validates_uniqueness_of :user_id, scope: :course_id
end
