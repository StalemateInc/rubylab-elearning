class AddImageToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :image, :string, null: true
  end
end
