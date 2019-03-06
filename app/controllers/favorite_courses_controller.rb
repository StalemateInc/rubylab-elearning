class FavoriteCoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  after_action :clear_flash

  # POST /courses/:id/add_favorite
  def create
    @favorite_course = FavoriteCourse.new(course: @course, user: current_user)

    if @favorite_course.save
      flash[:success] = 'Successfully added to favorite courses'
    else
      flash[:notice] = 'An error occured while adding to favorite courses'
    end
  end

  # DELETE /courses/:id/remove_favorite
  def destroy
    @favorite_course = FavoriteCourse.find_by(course: @course, user: current_user)

    if @favorite_course.destroy
      flash[:success] = 'Successfully removed from favorite courses'
    else
      flash[:notice] = 'An error occured while removing from favorite courses'
    end
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end
end
