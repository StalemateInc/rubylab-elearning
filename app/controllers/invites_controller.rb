# frozen_string_literal: true

class InvitesController < ApplicationController
  before_action :set_invite, only: %i[destroy create]
  after_action :delete_invite, only: %i[destroy create]

  # GET /invites
  def index; end

  # POST /organization/:id
  def create
    Membership.create(organization_id: @invite.organization.id, user_id: @invite.user.id)
    redirect_to @invite.organization
  end

  # DELETE /invites/:id
  def destroy
    redirect_to invites_path
  end

  private

  def set_invite
    @invite = Invite.find(params[:id])
  end

  def delete_invite
    @invite.destroy
  end
end
