class UsersController < Devise::SessionsController
  def new

  end

  def saved_searches
    Scraper.scrape_all
    @saved_searches = current_user ? current_user.saved_searches : []
  end

  def applied_jobs
    binding.pry
  end
end