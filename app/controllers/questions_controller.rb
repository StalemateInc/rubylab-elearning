class QuestionsController < ApplicationController
  def render_form
    respond_to do |format|
      case params[:type].to_i
      when 0
        format.html { render partial: 'questions/textbox_question_fields'}
      when 1
        format.html { render partial: 'questions/radio_question_fields'}
      else
        format.html { render partial: 'questions/checkbox_question_fields'}
      end
    end
  end

  def destroy
    question = Question.find(params[:question_id])
    respond_to do |format|
      format.json { render json: { success: question.destroy } }
    end
  end
end
