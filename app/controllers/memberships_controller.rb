# frozen_string_literal: true

class MembershipsController < ApplicationController
  before_action :set_organization
  before_action :set_membership, only: :destroy
  after_action :clear_flash, only: :destroy

  # GET /organizations/:id/manage/memberships
  def index
    @memberships = @organization.memberships.order('org_admin DESC')
  end

  # DELETE /organizations/:id/manage/memberships/:membership_id
  def destroy
    if @membership.destroy
      flash[:success] = "User @#{@membership.user.profile.nickname} was successfully kicked from the organization"
    else
      flash[:notice] = 'Error kicking a user from an organization'
    end
    respond_to do |format|
      format.js
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
