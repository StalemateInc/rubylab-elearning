class CoursesController < ApplicationController
  include Pundit
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_course, except: %i[index create new]

  # GET /courses
  def index
    public_courses = Course.where(visibility: :everyone)
    allowed_courses = current_user ? current_user.allowed_courses : []
    org_courses = current_user ? current_user.organizations.map(&:created_courses) : []
    org_courses.flatten!

    @courses = public_courses + allowed_courses + org_courses
  end

  # POST /courses
  def create
    @course = Course.new(course_params)
    allowed_users_ids = params[:course][:allowed_users] || []
    if params[:course][:is_org_creator]
      ownable_type = 'Organization'
      ownable_id = params[:course][:owner]
      Ownership.create(ownable_type: ownable_type, ownable_id: ownable_id, course: @course)
    else
      Ownership.create(ownable: current_user, course: @course)
    end
    allowed_users_ids.map do |user_id|
      user = User.find(user_id)
      CourseAccess.create(user: user, course: @course) if user
    end
    redirect_to @course if @course.save
  end

  # GET /courses/new
  def new
    @course = Course.new
    @users = {}
    User.all.map do |user|
      @users[user.email] = user.id unless user == current_user
    end
    @organizations = {}
    current_user.organizations.map do |org|
      @organizations[org.name] = org.id if current_user.in?(org.org_admin_list) && org.verified?
    end
  end

  # GET /courses/:id/edit
  def edit
    authorize @course

    @users = {}
    User.all.map do |user|
      @users[user.email] = user.id unless user == current_user
    end
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
    params.require(:course).permit(%i[name description duration difficulty visibility])
  end
end
