# frozen_string_literal: true

class UserDashboardController < ApplicationController
  before_action :authenticate_user!

  # GET /user
  def index; end

end
