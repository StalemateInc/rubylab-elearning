class RemoveCertificateReferenceFromCompletionRecord < ActiveRecord::Migration[5.2]
  def change
    remove_reference :completion_records, :certificate
  end
end
