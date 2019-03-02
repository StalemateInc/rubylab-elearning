namespace :import do
  desc "import courses from database to elasticsearch"
  task elasticsearch: :environment do
    puts "task run at #{ time = Time.now }"
    Course.__elasticsearch__.create_index!(force: true)
    Course.import
    puts "task complete for #{ time - Time.now }"
  end
end