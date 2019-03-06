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
    user_answers = UserAnswer.find_by(user: context.user, course: context.course)
    user_answers.destroy_all unless user_answers.blank?
    GenerateCertificateWorker.perform_async(record.id) if context.grade >= 90
  end
end