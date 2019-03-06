# frozen_string_literal: true

class UserDashboardController < ApplicationController
  before_action :authenticate_user!

  # GET /user
  def index
    @enrolled_courses = current_user.enrolled_courses.limit(5)
    @organization_courses = Course.accessible_organizations_courses(current_user).limit(5)
    @user_courses = Course.accessible_user_courses(current_user).limit(5)
    @finished_courses = current_user.completed_courses.limit(5)
    @favorite_courses = current_user.favorites.limit(5)
    @recommended_courses = Course.recommended_courses(current_user).limit(5)
  end
end
