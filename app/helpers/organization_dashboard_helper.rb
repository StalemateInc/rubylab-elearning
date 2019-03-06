module OrganizationDashboardHelper

  def id_for_selected_menu_organization(active)
    case active
    when :dashboard
      'v-pills-org-dashboard-tab'
    when :memberships
      'v-pills-org-users-tab'
    when :invites
      'v-pills-org-invites-tab'
    when :requests
      'v-pills-org-requests-tab'
    when :reports
      'v-pills-org-reports-tab'
    else
      ''
    end
  end

end
