class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end

  def test
    answer_list = AnswerList.new
    answer_list.answers = params[:answer_list][:answers]
    answer_list.correct_answers = params[:answer_list][:correct_answers].join(' ')
    answer_list.question = create_question
    answer_list.save
    respond_to do |format|
      format.json { render json: { test: true } }
    end
  end

  private

  def create_question
    question = Question.new(question_params)
    question.page = Page.first #stub
    question
  end

  def question_params
    params.require(:question).permit(:content, :question_type)
  end
end
