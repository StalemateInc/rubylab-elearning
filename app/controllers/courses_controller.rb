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
    if params[:course][:is_org_creator]
      ownable_type = 'Organization'
      ownable_id = params[:course][:owner]
      Ownership.create(ownable_type: ownable_type, ownable_id: ownable_id, course: @course)
    else
      Ownership.create(ownable: current_user, course: @course)
    end
    redirect_to @course if @course.save
  end

  # GET /courses/new
  def new
    @course = Course.new
    @organizations = {}
    current_user.organizations.to_a.map do |org|
      @organizations["#{org.name}"] = org.id if current_user.in?(org.org_admin_list)
    end
  end

  # GET /courses/:id/edit
  def edit
    authorize @course
  end

  # GET /courses/:id
  def show; end

  # PATCH /courses/:id
  def update
    redirect_to @course if @course.update(course_params)
  end

  # DELETE /courses/:id
  def destroy
    authorize @course
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
