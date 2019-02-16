class Organizations::JoinRequestPolicy < ApplicationPolicy
  def index?
    user.admin? || user.in?(record.org_admin_list)
  end

  def create?
    index?
  end

  def accept?
    index?
  end

  def decline?
    index?
  end

  def destroy?
    index?
  end

  def specify_reason?
    index?
  end
end