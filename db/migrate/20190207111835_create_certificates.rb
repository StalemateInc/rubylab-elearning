class CreateCertificates < ActiveRecord::Migration[5.2]
  def change
    create_table :certificates do |t|
      t.string :filename, null: false
      t.references :course
      t.timestamps
    end
  end
end
