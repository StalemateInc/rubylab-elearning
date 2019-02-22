class PagesController < ApplicationController
  include Pundit
  before_action :authenticate_user!
  before_action :set_course, except: :destroy
  before_action :set_page, only: :destroy

  # GET /courses/:course_id/pages
  def index
    @pages = Page.all_for(@course)
  end

  # POST /courses/:course_id/pages
  def create

    result = ConfigurePageBeforeInsertion(course: @course, index: params[:page_index].to_i)
    @page = Page.new(page_params.merge(course: @course, previous_page: result.previous_page, next_page: result.next_page))

    if @page.save
      flash[:success] = 'Page was successfully created'
      redirect_to(course_pages_path)
    else
      flash[:notice] = 'An error occurred while creating the page'
      redirect_back(fallback_location: root_path)
    end
  end

  # GET /courses/:course_id/pages/new
  def new
    @page = Page.new
  end

  # DELETE /courses/:id/pages/:id
  def destroy
    if @page.destroy
      flash[:success] = 'Page was successfully removed'
      redirect_back(fallback_location: root_path)
    else
      flash[:notice] = 'An error occurred while removing the page'
    end
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def page_params
    params.require(:page).permit(%i[html])
  end
end
