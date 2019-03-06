# frozen_string_literal: true

class SearchController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /search
  def search
    user = User.find_by_id(params[:search][:user_id]) || current_user
    result = PerformSearch.call(params: params, user: user)
    @results = result.results
    respond_to do |format|
      format.json { render json: @results }
      format.js
    end
  end

  # POST /user_dashboard_search
  def user_dashboard_search
    user = User.find_by_id(params[:search][:user_id]) || current_user
    if params[:search][:query] == ''
      @results = user.participations
    else
      result = PerformSearch.call(params: params, user: user)
      @results = result.results
      @results.map! { |mapped_result| mapped_result.participations.find_by(user: user) } unless @results.blank?
    end
    respond_to do |format|
      format.json { render json: @results }
      format.js
    end
  end

  # GET /search
  def index; end

end