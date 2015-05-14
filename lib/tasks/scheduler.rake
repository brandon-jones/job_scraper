desc "This task is called by the Heroku scheduler add-on"
task :scrape_jobs => :environment do
  puts "Getting job info..."
  Scraper.scrape_all
  puts "done."
end
