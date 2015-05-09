class SavedSearchesController < ApplicationController

  def create
    redirect_to root_url and return unless current_user
    fixed_params = SavedSearch.clean_params(params)
    if saved_search = SavedSearch.new(current_user).add(fixed_params["saved_searches"])
      redirect_to job_searches_path and return
    else
      redirect_to job_searches_path and return # this should end up showing an error
    end
  end

end