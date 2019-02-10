class UserAnswer < ApplicationRecord
  belongs_to :question
  belongs_to :course
  belongs_to :user
end
