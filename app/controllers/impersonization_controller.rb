class ImpersonizationController < ApplicationController
  

  def impersonate
    unless true_user && current_user && current_user != true_user
      id = current_user.id
      user = User.find(params[:id])
      impersonate_user(user)
      @impersonation = ImpersonationHistory.create(started_at: Time.now, impersonator_id: id,
        target_user_id: user.id)
    end
    redirect_back(fallback_location: root_path)
  end

  def stop_impersonating
    cu = current_user.id
    tu = true_user.id
    stop_impersonating_user
    impersonation = ImpersonationHistory.find_by(impersonator_id: tu,
                                 target_user_id: cu,
                                 ended_at: nil)
    impersonation.update(ended_at: Time.now)
    redirect_back(fallback_location: root_path)
  end
end
 