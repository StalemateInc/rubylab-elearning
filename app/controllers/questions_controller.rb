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
    question_content = params[:question][:content]
    question_type = params[:question][:question_type].to_i
    Question.create(content: question_content, page_id: Page.first.id, question_type: question_type) #stub
  end
end
