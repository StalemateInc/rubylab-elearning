# frozen_string_literal: true

class ParticipationsController < ApplicationController
  before_action :set_participation, except: %i[index create]

  def index
    @participations = current_user.participations
  end

  # make remote
  def destroy
    if @participation.destroy
      flash[:success] = 'You have successfully left this course'
    else
      flash[:notice] = 'An error occurred while leaving the course'
    end
  end

  # POST /courses/:id/enroll
  def create
    course = Course.find(params[:id])
    if Participation.create(user: current_user, course: course)
      flash[:success] = 'You have successfully enrolled this course'
    else
      flash[:notice] = 'An error occurred while enrolling the course'
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def set_participation
    
    binding.pry
    
    @participation = Participation.find(params[:id])
  end
end
