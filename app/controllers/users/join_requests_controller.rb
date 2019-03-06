# frozen_string_literal: true

class Users::JoinRequestsController < ApplicationController

  before_action :set_pending_requests
  before_action :set_join_request, only: :destroy
  after_action :clear_flash, only: :destroy

  # GET /user/requests
  def index
    @request_history = JoinRequest.where(user: current_user, status: %i[accepted declined])
  end

  # DELETE /user/requests/:join_request_id
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

  def set_join_request
    @join_request = JoinRequest.find(params[:join_request_id])
  end

  def set_pending_requests
    @pending_requests = JoinRequest.where(user: current_user, status: :pending)
  end

end
