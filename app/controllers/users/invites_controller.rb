# frozen_string_literal: true

class Users::InvitesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_invite, except: :index
  after_action :clear_flash, except: :index

  # GET user/invites
  def index
    @invites = Invite.where(user: current_user)
  end

  # PUT user/invites/:id/accept
  def accept
    membership = Membership.new(user: current_user, organization: @invite.organization)
    @invite.destroy
    if membership.save
      flash[:success] = "You have successfully joined the \"#{@invite.organization.name}\" organization"
    else
      flash[:notice] = 'An error occurred while joining the organization.'
    end
  end

  # PUT user/invites/:id/decline
  def decline
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