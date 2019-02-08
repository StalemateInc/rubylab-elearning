class CreateJoinRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :join_requests do |t|
      t.text :comment
      t.integer :status, default: 0
      t.references :user
      t.references :organization

      t.timestamps
    end
  end
end
