class Page < ApplicationRecord
  has_many :questions, dependent: :destroy
  belongs_to :course
  belongs_to :previous_page_id, class_name: 'Page', optional: true
end
