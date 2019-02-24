# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  # GET /user/profile
  def show; end

  # GET /user/profile/edit
  def edit; end

  # PATCH /user/profile
  def update
    @profile.remove_image!
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
    params.require(:profile).permit(%i[name surname nickname address birthday image remove_image])
  end
end
