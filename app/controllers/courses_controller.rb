# frozen_string_literal: true

class CoursesController < ApplicationController
  include Pundit
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_course, except: %i[index create new filter sortable]

  # GET /courses
  def index
    @sort_by = { 'Name': 'name', 'Completed count': 'completion_records',
                 'Rating': 'rating', 'Creation date': 'created_at' }
    @pagy, @courses = pagy_array(get_all_courses, items: 5)
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

  # GET /course/sortable
  def sortable
    @pagy, @courses = pagy_array(get_courses, items: 5)
    respond_to do |format|
      format.js
      format.html
    end
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

  def get_all_courses 
    courses = Course.all
    courses.reject do |course|
      if course.individuals?
        !course.owner?(current_user) && !current_user.in?(course.allowed_users)
      elsif course.organization?
        !course.owner?(current_user) && !current_user.in?(course.owner.users)
      end
    end.reject do |course|
      course.drafted? && !course.owner?(current_user)
    end
  end

  def get_courses
    courses = []
    if sort_params[2] == 'false' && sort_params[3] == 'false'
      courses = get_all_courses
    elsif sort_params[2] == 'true' && sort_params[3] == 'false'
      courses = current_user.favorites.to_a
    elsif sort_params[2] == 'false' && sort_params[3] == 'true'
      courses << current_user.organizations.map(&:created_courses)
      courses.flatten!
    else
      current_user.favorites.map do |course|
        courses << course if course.owner.in?(current_user.organizations)
      end
    end

    sort_by = sort_params[0] + '_' + sort_params[1]
    case sort_by
    when 'name_desc'
      courses.sort_by!(&:name).reverse!
    when 'name_asc'
      courses.sort_by!(&:name)
    when 'completion_records_desc'
      courses.sort_by! { |course| course.completion_records.count }.reverse!
    when 'completion_records_asc'
      courses.sort_by! { |course| course.completion_records.count }
    when 'rating_desc'
      courses.sort_by!(&:rating).reverse!
    when 'rating_asc'
      courses.sort_by!(&:rating)
    when 'created_at_desc'
      courses.sort_by!(&:rating).reverse!
    when 'created_at_asc'
      courses.sort_by!(&:rating)
    else
      courses
    end
    courses
  end

  def sort_params
    params[:sort].require(%i[sort_by direction favorites my_org])
  end
end
