class CreateFavoriteCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_courses do |t|
      t.references :user
      t.references :course
      t.timestamps
    end
  end
end
