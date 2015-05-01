class SavedSearchesController < ApplicationController

  def create
    redirect_to root_url and return unless current_user
    fixed_params = SavedSearches.clean_params(params)
    if saved_search = SavedSearches.add(current_user, fixed_params["saved_searches"].to_json)
      redirect_to job_searches_path and return
    else
      redirect_to job_searches_path and return # this should end up showing an error
    end
  end

end