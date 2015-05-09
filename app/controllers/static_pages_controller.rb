class StaticPagesController < ApplicationController

  def home
    Scraper.scrape_all
    @saved_searches = current_user ? current_user.saved_searches : []
  end

end