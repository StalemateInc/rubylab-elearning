# frozen_string_literal: true

class JoinRequestsController < ApplicationController

  before_action :set_organization
  before_action :set_join_request, except: :index
  after_action :clear_flash, only: %i[accept decline]

  # GET organizations/:id/request/:request_id
  def index
    @join_requests = JoinRequest.where(organization: @organization, status: :pending)
  end

  # POST organizations/:id/request/:request_id
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

  # DELETE organizations:/:id/request/:request_id
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

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def set_join_request
    @join_request = JoinRequest.find(params[:join_request_id])
  end

end
