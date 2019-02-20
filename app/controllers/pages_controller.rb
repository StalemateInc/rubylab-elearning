class PagesController < ApplicationController
  include Pundit
  before_action :authenticate_user!
  before_action :set_course

  # GET /courses/:id/pages
  def index
    @pages = []
    current_page = Page.find_by(course: @course, previous_page: nil)
    while current_page
      @pages << current_page
      current_page = current_page.next_page
    end
  end

  # POST /courses/:id/pages
  def create
    @page = Page.new(page_params)
    @page.course = @course

    last_page = Page.find_by(course: @course, next_page: nil)
    @page.previous_page = last_page

    @page.html = ''
    @page.css = ''

    if @page.save
      flash[:success] = 'Page was successfully created'
      redirect_to(course_pages_path)
    else
      flash[:notice] = 'An error occured while creating the page'
      redirect_back(fallback_locatoin: root_path)
    end
  end

  # GET /courses/:id/pages/new
  def new
    @page = Page.new
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def page_params
    params.require(:page).permit(%i[course previous_page next_page html css])
  end
end
