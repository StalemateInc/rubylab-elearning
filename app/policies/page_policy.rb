class PagePolicy < ApplicationPolicy

  # @user -> current_user
  # @record -> Page

  def index?
    user.admin? || record.course.owner?(user)
  end

  def new?
    index?
  end

  def create?
    index?
  end

  def edit?
    index?
  end

  def update?
    index?
  end

  def destroy?
    index?
  end

  def show?
    course = record.course
    prev_page = record.previous_page
    course.in?(user.enrolled_courses) \
      && CompletionRecord.find_by(user: user, course: course).nil? \
      && (prev_page.nil? ? true : prev_page.all_questions_answered_by?(user))
  end
end