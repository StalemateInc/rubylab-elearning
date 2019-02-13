class RemoveAnswerListIdFromQuestion < ActiveRecord::Migration[5.2]
  def change
    remove_reference :questions, :answer_list
  end
end
