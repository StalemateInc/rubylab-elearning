class FavoriteCoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course

  # POST /courses/:id/to_favorite
  def create
    @favorite_course = FavoriteCourse.new(course: @course, user: current_user)

    if @favorite_course.save
      flash[:success] = 'Successfully added to favorite courses'
    else
      flash[:notice] = 'An error occured while adding to favorite courses'
    end
    redirect_back(fallback_location: root_path)
  end

  # DELETE /courses/:id/remove_favorite
  def destroy
    @favorite_course = FavoriteCourse.find_by(course: @course, user: current_user)

    if @favorite_course.destroy
      flash[:success] = 'Successfully removed from favorite courses'
    else
      flash[:notice] = 'An error occured while removing from favorite courses'
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end
end
