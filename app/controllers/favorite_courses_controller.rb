class FavoriteCoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course

  # POST /courses/:id/favorite
  def create
    
    binding.pry
    
    # @favorite_course = FavoriteCourse.new(course: @course, user: current_user)
    # if @favorite_course.save
    #   flash[:success] = 'Successfully added to favorite courses'
    # else
    #   flash[:notice] = 'An error occured while adding to favorite courses'
    # end
    # redirect_back(fallback_location: root_path)
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end
end
