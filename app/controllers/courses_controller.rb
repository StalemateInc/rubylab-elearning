class CoursesController < ApplicationController
  include Pundit
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_course, except: %i[index create new]

  # GET /courses
  def index
    @courses = Course.all
  end

  # POST /courses
  def create
    @course = Course.new(course_params)
    redirect_to @course if @course.save
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/:id/edit
  def edit
  end

  # GET /courses/:id
  def show; end

  # PATCH /courses/:id
  def update
    redirect_to @course if @course.update(course_params)
  end

  # DELETE /courses/:id
  def destroy
    redirect_to courses_path if @course.destroy
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(%i[name duration difficulty])
  end
end
