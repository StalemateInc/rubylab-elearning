class CreateImpersonationHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :impersonation_histories do |t|
      t.datetime :started_at
      t.datetime :ended_at
      t.references :impersonator, references: :users
      t.references :target_user, references: :users
      t.timestamps
    end
  end
end
