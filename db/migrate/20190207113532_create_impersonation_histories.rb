class CreateImpersonationHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :impersonation_histories do |t|
      t.datetime :started_at
      t.datetime :ended_at
      t.references :impersonator, references: :impersonation_histories
      t.references :target_user, references: :impersonation_histories
      t.timestamps
    end
  end
end
