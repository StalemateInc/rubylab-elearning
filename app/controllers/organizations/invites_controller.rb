# frozen_string_literal: true

class Organizations::InvitesController < ApplicationController
  include Pundit

  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_invite, except: %i[index import create]
  before_action :authorize_through_organization
  after_action :clear_flash, except: :index

  # GET /organizations/:id/manage/invites
  def index
    @invites = Invite.where(organization: @organization)
  end

  # POST /organizations/:id/manage/import
  def import
    result = ImportUsersToOrganization.call(params: invite_params, organization: @organization)
    if result.success?
      flash[:success] = 'Import successful!'
    else
      flash[:notice] = 'An error occurred while importing users.'
    end
    redirect_to invites_organization_path(@organization)
  end

  # POST /organizations:/:id/manage/invites
  def create
    user = User.find_or_create_by(email: invite_params[:email])
    @invite = Invite.new(user: user, organization: @organization)
    if @invite.save
      flash[:success] = "Successfully invited user with email \"#{user.email}\"."
    else
      flash[:notice] = 'An error occurred inviting a user.'
    end
    respond_to do |format|
      format.js
    end
  end

  # DELETE /organizations/:id/manage/invites/:invite_id
  def destroy
    if @invite.destroy
      flash[:success] = 'Successfully destroyed an invite'
    else
      flash[:notice] = 'An error occurred while destroying an invite'
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def authorize_through_organization
    authorize @organization, policy_class: Organizations::InvitePolicy
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def set_invite
    @invite = Invite.find(params[:invite_id])
  end

  def invite_params
    params.require(:user).permit(%i[email[] csv])
  end
end