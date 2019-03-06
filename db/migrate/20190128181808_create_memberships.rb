# frozen_string_literal: true

class CreateMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships do |t|
      t.references :user, foreign_key: true
      t.references :organization, foreign_key: true
      t.boolean :org_admin, default: false
      t.timestamps
    end
  end
end
