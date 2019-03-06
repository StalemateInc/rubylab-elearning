class AddTimestampsToInvitesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :invites, :created_at, :datetime, null: false
    add_column :invites, :updated_at, :datetime, null: false
  end
end
