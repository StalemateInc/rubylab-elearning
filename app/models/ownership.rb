# frozen_string_literal: true

class Ownership < ApplicationRecord
  belongs_to :course
  belongs_to :ownable, polymorphic: true

  validates_uniqueness_of :course_id, scope: [:ownable_id, :ownable_type]
end
