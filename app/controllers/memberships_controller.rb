class MembershipsController < ApplicationController
  before_action :set_organization
  before_action :set_membership, only: :destroy
  after_action :clear_flash, only: :destroy

  # GET /organizations/:id/manage/memberships
  def index
    @memberships = @organization.memberships.where.not(org_admin: true)
  end

  # TODO: make remote
  # DELETE /organizations/:id/manage/memberships/:membership_id
  def destroy
    user = @membership.user
    if @membership.destroy
      flash[:success] = "User @#{user.nickname} was successfully kicked from the organization"
    else
      flash[:notice] = 'Error kicking a user from an organization'
    end
  end

  private

  def set_membership
    @membership = Membership.find(params[:membership_id])
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end
end
