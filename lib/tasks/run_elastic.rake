namespace :create_index do
  desc "create index and import courses from database to elasticsearch"
  task elasticsearch: :environment do
    puts "task run at #{ time = Time.now }"
    Course.__elasticsearch__.create_index!
    Course.import(force: true)
    AutoCompleteCreationTable.call
    AutoCompleteFillTable.call
    puts "task complete for #{ time - Time.now }"
  end
end