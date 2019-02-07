class OperatorSwitcherController < ApplicationController
  def change_operator
    session[:ownable_type] = params[:ownable_type]
    session[:ownable_id] = params[:ownable_id]

    redirect_back(fallback_location: root_path)
  end
end
