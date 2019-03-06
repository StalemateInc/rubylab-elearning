require 'course_grader'

class CalculateGrade < BaseInteractor

  # context:
  # course: Course, user: User, checked_text_questions: ActionParams

  def call
    questions = context.course.questions.includes(:answer_list)
    user_answers = questions.map { |q| q.user_answers.where(user: context.user) }
    fail_with_message('Failed to find question or user answers to process!') if questions.empty? || user_answers.empty?
    zipped = questions.zip(user_answers)
    context.grade = CourseGrader.new(zipped, context.checked_text_questions).calculate_grade
  end
end