class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :surname
      t.string :nickname
      t.string :address
      t.date :birthday
      t.timestamps
    end
  
    add_index :profiles, :nickname, unique: true
  end
end
