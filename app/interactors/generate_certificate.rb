class GenerateCertificate < BaseInteractor

  # context:
  # grade: Integer, user: User, course: Course

  def call
    record = CompletionRecord.create(score: context.grade,
                                     status: context.grade >= 90 ? :passed : :failed,
                                     course: context.course,
                                     user: context.user,
                                     date: Time.now)
    Participation.find_by(course: context.course, user: context.user).destroy
    GenerateCertificateWorker.perform_async(record.id) if context.grade >= 90
  end
end