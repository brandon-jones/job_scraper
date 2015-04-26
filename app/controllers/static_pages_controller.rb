class StaticPagesController < ApplicationController

  def home
    @saved_searches = $redis.smembers("saved_searches:#{current_user.id}")
  end

end