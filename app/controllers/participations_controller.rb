# frozen_string_literal: true

class ParticipationsController < ApplicationController
  include Pundit
  before_action :authenticate_user!
  before_action :set_participation, except: %i[index create]
  after_action :clear_flash, except: :index
  
  def index
    @participations = current_user.participations
  end

  # make remote
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

    @participation = Participation.create(user: current_user, course: @course)
    if @participation
      flash[:success] = 'You have successfully enrolled this course'
    else
      flash[:notice] = 'An error occurred while enrolling the course'
    end
  end

  private

  def set_participation
    @participation = Participation.find(params[:id])
  end
end
