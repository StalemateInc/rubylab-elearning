class CreateCourseAccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :course_accesses do |t|
      t.references :user
      t.references :course
      t.timestamps
    end
  end
end
