class Question < ApplicationRecord
  has_one :answer_list
  belongs_to :page
  accepts_nested_attributes_for :answer_list
end
