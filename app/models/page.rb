class Page < ApplicationRecord
  belongs_to :previous_page_id, class_name: 'Page', optional: true
end