class ImpersonizationController < ApplicationController
  def impersonate
    unless true_user && current_user && current_user != true_user
      id = current_user.id
      user = User.find(params[:id])
      if user.confirmed?
        impersonate_user(user)
        @impersonation = ImpersonationHistory.create(started_at: Time.now, impersonator_id: id,
                                                     target_user_id: user.id)
      else
        flash[:danger] = 'You can not impersonate unconfirmed user'
      end
    end
    redirect_to root_path
  end

  def stop_impersonating
    current_u = current_user.id
    true_u = true_user.id
    stop_impersonating_user
    impersonation = ImpersonationHistory.find_by(impersonator_id: true_u,
                                                 target_user_id: current_u,
                                                 ended_at: nil)
    impersonation.update(ended_at: Time.now)
    redirect_to root_path
  end
end
