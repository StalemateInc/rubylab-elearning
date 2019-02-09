class CoursePolicy < ApplicationPolicy
  def edit?
    user.admin? || check_owner
  end

  def update?
    edit?
  end

  def destroy?
    user.admin? || check_owner
  end

  private

  def check_owner
    if record.owner.instance_of?(User)
      record.owner == user
    else
      user.in?(record.owner.org_admin_list)
    end
  end
end
