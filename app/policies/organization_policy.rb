class OrganizationPolicy < ApplicationPolicy

  def edit?
    user.admin? || user.in?(record.org_admin_list)
  end

  def update?
    edit?
  end

  def destroy
    user.admin? || user.in?(record.org_admin_list)
  end
end