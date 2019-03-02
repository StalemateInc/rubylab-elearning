namespace :run_schedule_for_elastic do
  desc "run schedule wich run elasticsearch task"
  task elasticsearch: :environment do
    %{whenever --update-crontab --set environment='development'}
  end
end