class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.text :html, null: false
      t.text :css, null: false
      t.references :previous_page, references: :pages
      t.references :course
      t.timestamps
    end
  end
end
