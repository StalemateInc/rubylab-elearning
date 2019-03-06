class CreateUserAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :user_answers do |t|
      t.string :answer, null: false
      t.references :question
      t.references :user
      t.references :course
      t.timestamps
    end
  end
end
