class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end

  def test; end
end
