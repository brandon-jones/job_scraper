class UsersController < Devise::SessionsController
  def new
  end

  def saved_searches
    Scraper.scrape_all
    @saved_searches = current_user ? current_user.saved_searches : []
  end

  def saved_search_results
    return [] unless current_user
    @saved_search_result = current_user.saved_search_results
  end
end