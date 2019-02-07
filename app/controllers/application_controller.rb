# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:notice] = t "#{policy_name}.#{exception.query}", scope: 'pundit', default: :default
    redirect_to(request.referrer || root_path)
  end
end
