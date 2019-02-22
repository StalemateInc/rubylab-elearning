class MembershipPolicy < ApplicationPolicy
  def index?
    user.admin? || user.in?(record.org_admin_list)
  end

  def destroy?
    user.admin? || user.in?(record.org_admin_list)
  end

end