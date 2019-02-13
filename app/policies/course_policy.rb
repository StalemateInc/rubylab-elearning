class CoursePolicy < ApplicationPolicy
  def edit?
    user.admin? || record.owner?(user)
  end

  def update?
    edit?
  end

  def destroy?
    user.admin? || record.owner?(user)
  end
end
