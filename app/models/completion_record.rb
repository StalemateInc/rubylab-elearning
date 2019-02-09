class CompletionRecord < ApplicationRecord
  belongs_to :course
  belongs_to :user
  belongs_to :certificate
end
