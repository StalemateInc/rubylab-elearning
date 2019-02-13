class CreateInviteTable < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
      t.integer :user_id
      t.integer :organization_id
    end
  end
end
