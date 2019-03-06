# frozen_string_literal: true

class ParticipationsController < ApplicationController
  include Pundit
  before_action :authenticate_user!
  before_action :set_participation, except: %i[index create]
  after_action :clear_flash, except: :index

  # GET /user/participations
  def index
    @participations = current_user.participations
  end

  # DELETE /user/participations/:id
  def destroy
    @course = @participation.course
    if @participation.destroy
      flash[:success] = 'You have successfully left this course'
    else
      flash[:notice] = 'An error occurred while leaving the course'
    end
  end

  # POST /courses/:id/enroll
  def create
    @course = Course.find(params[:id])
    authorize @course, policy_class: ParticipationPolicy

    starting_page = Page.starting_for(@course)
    @participation = Participation.create(user: current_user,
                                          course: @course,
                                          page: starting_page)
    if @participation
      flash[:success] = 'You have successfully enrolled this course'
      redirect_to page_course_path(@course, starting_page) if starting_page
    else
      flash[:notice] = 'An error occurred while enrolling the course'
    end
  end

  private

  def set_participation
    @participation = Participation.find(params[:id])
  end
end
