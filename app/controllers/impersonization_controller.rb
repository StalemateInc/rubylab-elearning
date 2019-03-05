class ImpersonizationController < ApplicationController
  

  def impersonate
    id = current_user.id
    user = User.find(params[:id])
    impersonate_user(user)
    impersonation = ImpersonationHistory.create(started_at: Time.now, impersonator_id: id,
      target_user_id: user.id)
    redirect_to root_path
  end

  def stop_impersonating
    stop_impersonating_user
    impersonation = ImpersonationHistory.find_by(impersonator_id: current_user.id,
                                 target_user_id:  true_user.id,
                                 ended_at: nil)
    impersonation.update(ended_at: Time.now)
    redirect_to root_path
  end
end
 