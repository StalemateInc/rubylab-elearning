class CompletionRecord < ApplicationRecord
  has_one :certificate, dependent: :destroy
  belongs_to :course
  belongs_to :user
end
