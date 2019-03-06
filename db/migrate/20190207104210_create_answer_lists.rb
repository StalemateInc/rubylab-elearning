class CreateAnswerLists < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :answer_lists do |t|
      t.hstore :answers, null: false
      t.string :correct_answers, null: false
      t.timestamps
    end
  end
end
