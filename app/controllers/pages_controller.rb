class PagesController < ApplicationController
  include Pundit
  before_action :authenticate_user!
  before_action :set_course, except: :delete
  before_action :set_page, only: :delete

  # GET /courses/:course_id/pages
  def index
    @pages = build_page_sequence
  end

  # POST /courses/:course_id/pages
  def create
    @page = Page.new(page_params)
    @page.course = @course

    page_index = params[:page_index].to_i
    insert_page(page_index)

    @page.html = ''
    @page.css = ''

    if @page.save
      flash[:success] = 'Page was successfully created'
      redirect_to(course_pages_path)
    else
      flash[:notice] = 'An error occured while creating the page'
      redirect_back(fallback_location: root_path)
    end
  end

  # GET /courses/:course_id/pages/new
  def new
    @page = Page.new
  end

  # DELETE /courses/:course_id/pages/:id
  def delete
    if @page.destroy
      flash[:success] = 'Page was successfully removed'
      redirect_back(fallback_location: root_path)
    else
      flash[:notice] = 'An error occured while removing the page'
    end
  end

  private

  def build_page_sequence
    first_page = Page.find_by(course: @course, previous_page: nil)
    first_page ? first_page.full_sequence : []
  end

  def insert_page(index)
    pages = build_page_sequence
    @page.previous_page = (index - 2).negative? ? nil : pages[index - 2]
    @page.next_page = pages[index - 1]
  end

  def set_page
    @page = Page.find(params[:id])
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def page_params
    params.require(:page).permit(%i[course previous_page next_page html css page_id])
  end
end
