class Question < ApplicationRecord
  has_one :answer_list, dependent: :destroy
  belongs_to :page
  has_many :user_answers, dependent: :destroy
  enum question_type: %i[radio checkbox textbox]
end
