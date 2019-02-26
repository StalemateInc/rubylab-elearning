# frozen_string_literal: true

class UserDashboardController < ApplicationController
  before_action :authenticate_user!

  # GET /user
  def index
    @favorite_courses = current_user.favorites.limit(5)
  end

end
