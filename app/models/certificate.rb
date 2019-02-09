class Certificate < ApplicationRecord
  has_one :completion_record
  belongs_to :course
end
