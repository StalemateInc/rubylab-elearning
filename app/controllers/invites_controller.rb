# frozen_string_literal: true

class InvitesController < ApplicationController
  before_action :set_invite

  def index; end

  def accept
    if @invite.nil?
      redirect_to root_path
    else
      @organization_id = @invite.organization_id
      user_id = @invite.user_id
      Membership.create(organization_id: @organization_id, user_id: user_id)
      @invite.destroy
      redirect_to organization
    end
  end

  def destroy
    if @invite.nil?
      redirect_to root_path
    else
      @invite.destroy
      redirect_to invites_path
    end
  end


  private

  def set_invite
    id = params[:id]
    if !id.nil?
      @invite = Invite.find(id)
    end
  end

  def organization
    Organization.find(@organization_id)
  end
end
