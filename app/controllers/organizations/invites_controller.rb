# frozen_string_literal: true

class Organizations::InvitesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_invite, except: :index
  before_action :authorize_through_organization
  after_action :clear_flash, except: :index

  # GET /organizations/:id/manage/invites
  def index
    @invites = Invite.where(organization: @organization)
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
end