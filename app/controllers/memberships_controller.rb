class MembershipsController < ApplicationController
  before_action :set_organization
  after_action :clear_flash, only: :destroy

  # DELETE /organizations/:organization_id/membership
  def destroy
    membership = @organization.memberships.find_by(user: current_user)
    if membership.destroy
      flash[:success] = 'You have successfully left the organization.'
    else
      flash[:notice] = 'Error occurred while leaving the group.'
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end
end
