class AddImageToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :image, :string, null: true
  end
end
