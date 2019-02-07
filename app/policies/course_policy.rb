class CoursePolicy < ApplicationPolicy
  def edit?
    user.admin? || record.ownership.ownable == user
  end

  def update?
    edit?
  end

  def destroy?
    user.admin? || record.ownership.ownable == user
  end
end
