class CoursePolicy < ApplicationPolicy
  def edit?
    user.admin? || record.owner?(user)
  end

  def update?
    edit?
  end

  def publish?
    user.admin? || record.owner?(user)
  end

  def archive?
    user.admin? || record.owner?(user)
  end
end
