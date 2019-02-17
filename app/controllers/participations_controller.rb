# frozen_string_literal: true

class ParticipationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_participation, except: :index

  # GET /user/participations
  def index
    @participations = current_user.participations
  end

  # DELETE /user/participations/:id
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
