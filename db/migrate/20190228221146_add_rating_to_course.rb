class AddRatingToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :rating, :integer
  end
end
