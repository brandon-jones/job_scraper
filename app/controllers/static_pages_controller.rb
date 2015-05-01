class StaticPagesController < ApplicationController

  def home
    Scraper.scrape_all
    # @saved_searches = SavedSearches.all(current_user)
    @saved_searches = current_user.saved_searches
  end

end