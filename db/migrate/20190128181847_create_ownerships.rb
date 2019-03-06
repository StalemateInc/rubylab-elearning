# frozen_string_literal: true

class CreateOwnerships < ActiveRecord::Migration[5.2]
  def change
    create_table :ownerships do |t|
      t.references :ownable, polymorphic: true, index: true
      t.references :course, foreign_key: true
      t.timestamps
    end
  end
end
