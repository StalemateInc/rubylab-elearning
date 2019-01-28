# frozen_string_literal: true

class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :name
      t.integer :duration
      t.integer :difficulty
      t.integer :views, default: 0
      t.timestamps
    end
  end
end
