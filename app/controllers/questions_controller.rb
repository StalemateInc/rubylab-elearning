class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end

  def render_form
    @question = Question.new
    respond_to do |format|
      format.html { render partial: 'questions/checkbox_question', locals: { page_id: params[:page_id] } }
    end
  end

  def create
    answer_list = AnswerList.new
    answer_list.answers = params[:answer_list][:answers]
    answer_list.correct_answers = params[:answer_list][:correct_answers].join(' ')
    answer_list.question = create_empty_question
    answer_list.save
    respond_to do |format|
      format.json { render json: { test: true } }
    end
  end

  private

  def create_empty_question
    question = Question.new(question_params)
    question.page = Page.first #stub
    question
  end

  def question_params
    params.require(:question).permit(:content, :question_type)
  end
end
