# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :set_profile

  def show; end

  def edit; end

  def update
    if @profile.update(profile_params)
      flash[:success] = 'You have successfully updated your profile'
    else
      flash[:notice] = 'An error occurred while updating your profile'
    end
    redirect_to profile_path(@profile)
  end

  private

  def set_profile
    @profile = current_user.profile
  end

  def profile_params
    params.require(:profile).permit(%i[name surname nickname address birthday])
  end
end