class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.text :content, null: false
      t.integer :type
      t.references :page
      t.references :answer_list
      t.timestamps
    end
  end
end
