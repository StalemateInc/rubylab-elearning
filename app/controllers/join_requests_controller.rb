# frozen_string_literal: true

class JoinRequestsController < ApplicationController

  before_action :set_organization
  before_action :set_join_request, except: %i[index create]
  after_action :clear_flash, only: %i[create accept decline destroy]

  # GET organizations/:id/requests/:request_id
  def index
    @join_requests = JoinRequest.where(organization: @organization, status: :pending)
  end

  # POST /organizations/:id/requests
  def create
    @join_request = JoinRequest.new(user: current_user, organization: @organization, status: :pending)
    if @join_request.save
      flash[:success] = 'Request has been sent. Please await confirmation from the organization administrator.'
    else
      flash[:notice] = 'Error sending a request, please, try again later.'
    end
    respond_to do |format|
      format.js
    end
  end

  # PUT /organizations/:id/requests/:request_id/accept
  def accept
    result = AcceptJoinRequest.call(user: @join_request.user,
                                    organization: @organization,
                                    request: @join_request)
    if result.success?
      flash[:success] = result.message
    else
      flash[:notice] = result.errors
    end
    respond_to do |format|
      format.js
    end
  end

  # PUT /organizations:/:id/requests/:request_id/decline
  def decline
    result = RejectJoinRequest.call(user: @join_request.user,
                                    organization: @organization,
                                    request: @join_request)
    if result.success?
      flash[:success] = result.message
    else
      flash[:notice] = result.errors
    end
    respond_to do |format|
      format.js
    end
  end

  # DELETE /organizations:/:id/requests/:request_id
  def destroy
    if @join_request.destroy
      flash[:success] = 'Join request successfully cancelled.'
    else
      flash[:notice] = 'An error occurred while cancelling request'
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def set_join_request
    @join_request = JoinRequest.find(params[:join_request_id])
  end

end
