# frozen_string_literal: true

class Users::InvitesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_invite, only: %i[accept destroy]

  # GET user/invites
  def index
    @invites = Invite.where(user: current_user)
  end

  # PUT user/invites/:id/accept
  # make remote
  def accept
    membership = Membership.new(user: current_user, organization: @invite.organization)
    @invite.destroy
    if membership.save
      flash[:success] = "You have successfully joined the \"#{@invite.organization.name}\" organization"
    else
      flash[:notice] = 'An error occured while joining the organization.'
    end
    # accept invite here
  end

  # PUT user/invites/:id/decline
  # make remote
  def destroy
    if @invite.destroy
      flash[:success] = 'You have successfully declined the invitation'
    else
      flash[:notice] = 'An error occurred while declining the invitation.'
    end
  end

  private

  def set_invite
    @invite = Invite.find(params[:id])
  end

end