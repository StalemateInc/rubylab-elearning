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

  # GET /courses/:id/pages/new
  def new
    @page = Page.new
  end

  # POST /courses/:id/pages
  def create
    # @page = Page.create(page_params)
  end

  def edit; end

  def update; end

  def destroy; end

  private

  def page_params
    params.require(:page).permit(:html)
  end

  def set_course
    @course = Course.find(params[:id])
  end
end
