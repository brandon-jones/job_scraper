class UsersController < Devise::SessionsController
  before_action :authenticated
  
  def new
  end

  def saved_searches
    @saved_searches = current_user ? current_user.saved_searches : []
  end

  def saved_search_results
    return [] unless current_user
    @saved_search_result = current_user.saved_search_results
  end
end