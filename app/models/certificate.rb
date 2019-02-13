class Certificate < ApplicationRecord
  belongs_to :completion_record
  belongs_to :course
end
