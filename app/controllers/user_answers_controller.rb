class UserAnswersController < ApplicationController

  before_action :set_course
  before_action :set_page
  after_action :clear_flash

  # POST /courses/:id/user_answers
  def store
    created_amount = 0
    user_answer_params.each do |question_id, answer|
      unless UserAnswer.find_by(user: current_user, question_id: question_id)
        answer = answer.instance_of?(Array) ? answer.join(' ') : answer
        UserAnswer.create(course: @course, question_id: question_id, user: current_user, answer: answer)
        created_amount += 1
      end
    end
    flash[:success] = "Successfully saved #{created_amount} answers!"
    respond_to(&:js)
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def set_page
    @page = Page.find(params[:page_id])
  end

  def user_answer_params
    params.require(:user_answers)
  end
end