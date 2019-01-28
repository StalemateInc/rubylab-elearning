# frozen_string_literal: true

class Participation < ApplicationRecord
  belongs_to :course
  belongs_to :user
end
