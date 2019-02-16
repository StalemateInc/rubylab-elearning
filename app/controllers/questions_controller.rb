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
  end

  private

  def create_question
    question_content = params[:question][:content]
    Question.create(content: question_content, page_id: Page.first.id) #stub
  end
end
