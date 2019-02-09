class AddQuestionIdToAnswerList < ActiveRecord::Migration[5.2]
  def change
    add_reference :answer_lists, :question
  end
end
