class AddCompletionRecordReferenceToCertificate < ActiveRecord::Migration[5.2]
  def change
    add_reference :certificates, :completion_record
  end
end
