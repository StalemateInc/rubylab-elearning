class AddDefaultValueToStatusInCourses < ActiveRecord::Migration[5.2]
  def change
    change_column :courses, :status, :integer, default: 0
  end
end
