class CreateCompletionRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :completion_records do |t|
      t.integer :score, null: false
      t.integer :status, null: false
      t.datetime :date
      t.references :certificate
      t.references :user
      t.references :course
      t.timestamps
    end
  end
end
