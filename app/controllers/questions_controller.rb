class QuestionsController < ApplicationController
  def render_form
    respond_to do |format|
      case params[:type].to_i
      when 0
        format.html { render partial: 'questions/textbox_question' }
      when 1
        format.html { render partial: 'questions/radio_question' }
      else
        format.html { render partial: 'questions/checkbox_question' }
      end
    end
  end
end
