class AddAnswerListQuestionReference < ActiveRecord::Migration[5.2]
  def change
    add_reference :answer_lists, :question, foreign_key: true
  end
end
