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

  def set_course
    @course = Course.find(params[:course_id])
  end
end
