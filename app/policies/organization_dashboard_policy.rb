class OrganizationDashboardPolicy < ApplicationPolicy

  def index?
    user.admin? || user.in?(record.org_admin_list)
  end

end