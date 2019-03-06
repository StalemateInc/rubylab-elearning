# frozen_string_literal: true

class MembershipsController < ApplicationController
  include Pundit
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_membership, only: :destroy
  after_action :clear_flash, only: :destroy

  # GET /organizations/:id/manage/memberships
  def index
    authorize @organization, policy_class: MembershipPolicy
    @memberships = @organization.memberships.order('org_admin DESC')
  end

  # DELETE /organizations/:id/manage/memberships/:membership_id
  def destroy
    authorize @organization, policy_class: MembershipPolicy
    if @membership.destroy
      flash[:success] = "User @#{@membership.user.email} was successfully kicked from the organization"
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
