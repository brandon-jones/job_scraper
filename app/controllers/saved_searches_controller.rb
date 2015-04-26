class SavedSearchesController < ApplicationController

  def create
    redirect_to root_url and return unless current_user
    fixed_params = SavedSearches.clean_params(params)
    # info_to_save = SavedSearches.save_data(params)
    $redis.sadd("saved_searches:#{current_user.id}", fixed_params["saved_searches"])
    redirect_to job_searches_path and return
  end

end