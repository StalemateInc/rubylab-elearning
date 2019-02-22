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
    # TODO; Add completion state enum to model and this check!
    course.in?(user.enrolled_courses) && CompletionRecord.find_by(user: user, course: course).nil?
  end
end