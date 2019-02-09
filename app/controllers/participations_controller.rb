# frozen_string_literal: true

class ParticipationsController < ApplicationController
  before_action :set_participation, except: :index

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

  private

  def set_participation
    @participation = Participation.find(params[:id])
  end

end
