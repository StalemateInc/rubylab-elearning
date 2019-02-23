# frozen_string_literal: true

class UserDashboardController < ApplicationController
  before_action :authenticate_user!

  # GET /user
  def index
    @favorite_courses = FavoriteCourse.where(user: current_user)
  end

end
