class GenerateCertificate < BaseInteractor

  # context:
  # grade: Integer, user: User, course: Course

  def call
    CompletionRecord.create(score: context.grade,
                            status: context.grade >= 90 ? :passed : :failed,
                            course: context.course,
                            user: context.user,
                            date: Time.now)
    Participation.find_by(course: context.course, user: context.user).destroy
    if context.grade >= 90
      # generate certificate here or initiate certificate builder worker
    end
  end
end