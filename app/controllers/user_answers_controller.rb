class UserAnswersController < ApplicationController

  before_action :set_course

  # POST /courses/:id/user_answers
  def store
    created_amount = 0
    @saved_ids = []
    user_answer_params.each do |question_id, answer|
      unless UserAnswer.find_by(user: current_user, question_id: question_id)
        answer = answer.join(',') if answer.instance_of? Array
        UserAnswer.create(course: @course, question_id: question_id, user: current_user, answer: answer)
        @saved_ids.push(question_id)
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

  def user_answer_params
    params.require(:user_answers)
  end
end