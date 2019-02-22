class Organizations::JoinRequestPolicy < ApplicationPolicy
  def index?
    user.admin? || user.in?(record.org_admin_list)
  end

  def create?
    true
  end

  def accept?
    index?
  end

  def decline?
    index?
  end

  def destroy?
    true
  end

  def specify_reason?
    index?
  end
end