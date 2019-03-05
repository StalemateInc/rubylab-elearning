class Certificate < ApplicationRecord
  belongs_to :completion_record
  belongs_to :course

  after_destroy { |record| File.delete(Rails.root.join("/public/uploads/certificates/#{record.filename}")) }
end
