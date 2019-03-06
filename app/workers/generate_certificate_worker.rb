# frozen_string_literal: true

require 'certificate_builder/certificate_builder'

class GenerateCertificateWorker
  include Sidekiq::Worker

  def perform(completion_record_id)
    completion_record = CompletionRecord.find(completion_record_id)
    course = completion_record.course
    user = completion_record.user
    profile = user.profile
    builder = CertificateBuilder.new(name: profile.name,
                                     surname: profile.surname,
                                     course: course.name,
                                     date: Time.now.strftime('%B %d, %Y'),
                                     grade: "#{completion_record.score}%")
    certificate_name = builder.build
    Certificate.create(filename: certificate_name, course: course, completion_record: completion_record)
  end
end