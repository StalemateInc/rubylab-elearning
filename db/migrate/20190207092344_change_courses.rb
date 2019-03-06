class ChangeCourses < ActiveRecord::Migration[5.2]
  def change
    remove_column :courses, :views
    add_column :courses, :description, :text
    add_column :courses, :status, :integer
    add_column :courses, :visibility, :integer
  end
end
