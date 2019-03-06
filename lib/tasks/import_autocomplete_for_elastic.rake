namespace :import_autocomplete do
  desc "import course name for autocomplete from database to elasticsearch"
  task elasticsearch: :environment do
    puts "task run at #{ time = Time.now }"
    AutoCompleteCreationTable.call
    AutoCompleteFillTable.call
    puts "task complete for #{ time - Time.now }"
  end
end