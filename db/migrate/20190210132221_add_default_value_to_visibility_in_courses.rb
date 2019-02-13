class AddDefaultValueToVisibilityInCourses < ActiveRecord::Migration[5.2]
  def change
    change_column :courses, :visibility, :integer, default: 0
  end
end
