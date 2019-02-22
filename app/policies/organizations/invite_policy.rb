class Organizations::InvitePolicy < ApplicationPolicy
  def index?
    user.admin? || user.in?(record.org_admin_list)
  end

  def create?
    index?
  end

  def destroy?
    index?
  end
end