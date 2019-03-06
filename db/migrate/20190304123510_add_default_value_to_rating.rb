class AddDefaultValueToRating < ActiveRecord::Migration[5.2]
  def change
    change_column :courses, :rating, :integer, default: 0
  end
end
