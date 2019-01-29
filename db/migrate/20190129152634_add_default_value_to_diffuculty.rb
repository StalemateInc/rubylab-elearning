class AddDefaultValueToDiffuculty < ActiveRecord::Migration[5.2]
  def change
    change_column :courses, :difficulty, :integer, default: 0
  end
end
