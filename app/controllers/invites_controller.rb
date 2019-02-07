# frozen_string_literal: true

class InvitesController < ApplicationController
  # before_action :set_invite, except: %i[accept]

  def notificate; end

  def accept
    if invite.nil?
      redirect_to root_path
    else
      @organization_id = invite.organization_id
      @user_id = invite.user_id
      Membership.create(organization_id: @organization_id, user_id: @user_id)
      Invite.destroy(invite.id)
      redirect_to organization
    end
  end

  def destroy
    if invite.nil?
      redirect_to root_path
    else
      Invite.destroy(invite.id)
      redirect_to invites_path
    end
  end


  private

  def invite
    Invite.find(params[:id])
  end

  def organization
    Organization.find(@organization_id)
  end
end
