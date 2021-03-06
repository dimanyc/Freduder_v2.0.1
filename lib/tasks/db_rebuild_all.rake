namespace :db_tasks do
  desc "Rebuild database"
  task :rebuild, [] => :environment do
    raise "Not allowed to run on production" if Rails.env.production?

    Rake::Task['db:drop'].execute
    Rake::Task['db:migrate'].execute
  end
end