class PagesController < ApplicationController
  include Pundit
  before_action :authenticate_user!
  before_action :set_course
  before_action :set_page, except: %i[index new create]

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
    @page = Page.create(page_params.merge(course: @course))
    respond_to do |format|
      format.html { redirect_to pages_course_path(@course) }
    end
  end

  # GET /courses/:id/pages
  def edit; end

  # PATCH /courses/:id/pages/:page_id
  def update
    if @page.update(page_params)
      flash[:success] = 'Page update successful.'
    else
      flash[:notice] = 'Failed to update a page.'
    end
    redirect_to pages_course_path(@course)
  end

  # make remote
  # DELETE /courses/:id/pages/:page_id
  def destroy
    if @page.destroy
      flash[:success] = 'Successfully deleted a page.'
    else
      flash[:notice] = 'Failed to delete a page.'
    end
    redirect_to pages_course_path(@course)
  end

  private

  def page_params
    params.require(:page).permit(:html)
  end

  def set_page
    @page = Page.find(params[:page_id])
  end

  def set_course
    @course = Course.find(params[:id])
  end
end
