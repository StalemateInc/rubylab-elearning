# frozen_string_literal: true

class CoursesController < ApplicationController
  include Pundit
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_course, except: %i[index create new]

  # GET /courses
  def index
    @courses = Course.all

    @courses = @courses.reject do |course|
      if course.individuals?
        !course.owner?(current_user) && !current_user.in?(course.allowed_users)
      elsif course.organization?
        !course.owner?(current_user) && !current_user.in?(course.owner.users)
      end
    end.reject do |course|
      course.drafted? && !course.owner?(current_user)
    end
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

    if @course.save
      flash[:success] = 'You have successfully created the course'
      redirect_to @course
    else
      flash[:danger] = 'An error occurred while creating the course'
      redirect_back(fallback_location: root_path)
    end
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

    @organizations = {}
    current_user.organizations.map do |org|
      @organizations[org.name] = org.id if current_user.in?(org.org_admin_list) && org.verified?
    end
  end

  # GET /courses/:id
  def show
    @participation = Participation.find_by(user: current_user, course: @course)
  end

  # PATCH /courses/:id
  def update
    allowed_users_ids = params[:allowed_users] || []
    ownership = @course.ownership
    CourseAccess.where(course: @course).destroy_all

    if params[:course][:is_org_creator]
      org = Organization.find(params[:course][:owner])
      ownership.update(ownable: org)
    else
      ownership.update(ownable: current_user)
    end

    allowed_users_ids.map do |user_id|
      user = User.find(user_id)
      CourseAccess.create(user: user, course: @course) if user
    end

    redirect_to @course if @course.update(course_params)
  end

  # PATCH /courses/:id/archive
  def archive
    authorize @course

    if @course.archived!
      flash[:success] = 'You have successfully archived the course'
      redirect_to courses_path
    else
      flash[:danger] = 'An error occurred while archiving the course'
      redirect_back(fallback_location: root_path)
    end
  end

  # PATCH /courses/:id/publish
  def publish
    authorize @course

    @course.published!
    flash[:success] = 'Course successfully published'
    redirect_back(fallback_location: root_path)
  end

  # PATCH /courses/:id/rate
  def rate
    if Assessment.find_by(user: current_user, course: @course).nil?
      rating = params[:rating]
      Assessment.create(value: rating, user: current_user, course: @course)
      new_rating = @course.rating ? (@course.rating.to_i + rating.to_i) / Assessment.where(course: @course).count : rating
      @course.update(rating: new_rating)
      flash[:success] = 'Your rating successfully recorded'
    else
      flash[:danger] = 'You have already rated this course.'
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(%i[name description duration difficulty visibility image remove_image])
  end
end
