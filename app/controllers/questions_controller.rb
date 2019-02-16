class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end

  def test
    answer_list = AnswerList.new(answer_list_params)
    answer_list.answers = params[:answer_list][:answers]
    answer_list.correct_answers = params[:answer_list][:correct_answers].join(' ')
    answer_list.question = create_question
    answer_list.save
  end

  private

  def create_question
    question_content = params[:question][:content]
    Question.create(content: question_content, page_id: Page.first.id)
  end

  def answer_list_params
    params.require(:answer_list).permit(%i[answers correct_answers])
  end
end
