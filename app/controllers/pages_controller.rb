class PagesController < ApplicationController
  include Pundit
  before_action :authenticate_user!
  before_action :set_course

  # GET /courses/:id/pages
  def index
    @pages = build_page_sequence
  end

  # POST /courses/:id/pages
  def create
    @page = Page.new(page_params)
    @page.course = @course

    pages = build_page_sequence
    page_index = params[:page_index].to_i
    @page.previous_page = (page_index - 2).negative? ? nil : pages[page_index - 2]
    @page.next_page = pages[page_index - 1]
    
    binding.pry
    
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

  def build_page_sequence
    pages = []
    current_page = Page.find_by(course: @course, previous_page: nil)
    while current_page
      pages << current_page
      current_page = current_page.next_page
    end
    pages
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def page_params
    params.require(:page).permit(%i[course previous_page next_page html css page_id])
  end
end
