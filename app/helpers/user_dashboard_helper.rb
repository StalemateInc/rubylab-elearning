# frozen_string_literal: true

module UserDashboardHelper

  def get_id_for_active_menu_item(active)
    case active
    when :dashboard
      'v-pills-dashboard-tab'
    when :profile
      'v-pills-profile-tab'
    when :participations
      'v-pills-courses-tab'
    when :certificates
      'v-pills-certificates-tab'
    when :messages
      'v-pills-messages-tab'
    else
      ''
    end
  end
end
