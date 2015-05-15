desc "This task is called by the Heroku scheduler add-on"
task :scrape_jobs => :environment do
  puts "Getting job info..."
  user_ids = Scraper.scrape_all

  user_ids.each do |user_id|
    user = User.find_by_id(user_id)
    user.notify_new_jobs
  end
  puts "done."
end
