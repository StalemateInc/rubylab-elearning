class Page < ApplicationRecord
  has_many :questions, dependent: :destroy
  belongs_to :course
  belongs_to :previous_page_id, class_name: 'Page', optional: true

   after_commit on: [:create] do
    Course.find_by(id: self.course_id).__elasticsearch__.update_document
  end

  after_commit on: [:update] do
    Course.find_by(id: self.course_id).__elasticsearch__.update_document
  end

  after_commit on: [:destroy] do
    Course.find_by(id: self.course_id).__elasticsearch__.update_document
  end
end
