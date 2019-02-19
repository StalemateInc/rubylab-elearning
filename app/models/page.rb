class Page < ApplicationRecord
  has_many :questions, dependent: :destroy
  belongs_to :course
  belongs_to :previous_page, class_name: 'Page', optional: true
  belongs_to :next_page, class_name: 'Page', optional: true
  before_save :set_page
  before_destroy :remove_page

  def set_page
    page_prev = previous_page
    page_next = next_page

    transaction do
      page_prev.update(next_page: self) if page_prev && page_prev.next_page != self
      page_next.update(previous_page: self) if page_next && page_next.previous_page != self
    end
  end

  def remove_page
    page_prev = previous_page
    page_next = next_page

    transaction do
      page_prev.update(next_page: page_next) if page_prev
      page_next.update(previous_page: page_prev) if page_next
    end
  end
end
