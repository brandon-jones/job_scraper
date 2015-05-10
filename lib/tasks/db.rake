namespace :db do
  desc "Database custom drop"
  task :myreset => :environment  do
    if Rails.env == 'development'
      puts 'dropping databases'
      system("rake db:drop RAILS_ENV=test && rake db:drop RAILS_ENV=development")
      puts 'creating the databases'
      system("rake db:create RAILS_ENV=test && rake db:create RAILS_ENV=development")
      puts 'migrating databases'
      system("rake db:migrate RAILS_ENV=test && rake db:migrate RAILS_ENV=development")
      system("rm -rf /Users/bjones/Documents/Development/Ruby/Jones_Jems/jones_jems/public/system/pictures")
      puts 'flushing redis'
      $redis.flushall
    else
      puts 'ENV NOT DEV DUMBASS DONT DO THIS'
    end
  end
end