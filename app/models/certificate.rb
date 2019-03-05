class Certificate < ApplicationRecord
  belongs_to :completion_record
  belongs_to :course

  after_destroy do |record|
    full_filepath = Rails.root.join("/public/uploads/certificates/#{record.filename}")
    File.delete(full_filepath) if File.exists?(full_filepath)
  end

end
