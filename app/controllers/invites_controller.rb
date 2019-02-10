# frozen_string_literal: true

class InvitesController < ApplicationController
  before_action :set_invite, only: [:destroy, :create]
  after_action :delete_invite, only: [:destroy, :create]

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
    id = params[:id]
    if !id.nil?
      @invite = Invite.find(id)
    end
  end

  def delete_invite
    @invite.destroy
  end
end
