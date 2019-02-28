class CheckController < ApplicationController

  before_action :set_course
  before_action :set_user, except: :index

  # GET /courses/:id/check/
  def index
    @awaiting_participations = @course.participations.where(await_check: true)
  end

  # GET /courses/:id/check/:user_id/
  def show
    questions = @course.questions.includes(:answer_list)
    user_answers = questions.map { |q| q.user_answers.where(user: @user) }
    @zipped = questions.zip(user_answers)
  end

  # POST /courses/:id/check/:user_id/grade
  def grade; end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def checked_params
    params.require(:checked)
  end
end