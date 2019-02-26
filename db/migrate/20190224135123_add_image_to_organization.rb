class AddImageToOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :image, :string, null: true
  end
end
