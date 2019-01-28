# frozen_string_literal: true

class Ownership < ApplicationRecord
  belongs_to :course
  belongs_to :ownable, polymorphic: true
end
