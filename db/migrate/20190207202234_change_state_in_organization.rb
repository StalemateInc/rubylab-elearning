class ChangeStateInOrganization < ActiveRecord::Migration[5.2]
  def change
    remove_column :organizations, :state
    add_column :organizations, :state, :integer
  end
end
