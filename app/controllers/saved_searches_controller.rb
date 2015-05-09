class SavedSearchesController < ApplicationController

  def create
    redirect_to root_url and return unless current_user
    fixed_params = SavedSearch.clean_params(params)
    if saved_search = SavedSearch.new(current_user).add(fixed_params["saved_searches"])
      redirect_to saved_searches_new_path and return
    else
      redirect_to saved_searches_new_path and return # this should end up showing an error
    end
  end

  def new
    @job_searches = JobSearch.all
  end

  def destroy
    redirect_to root_url and return unless current_user
    respond_to do |format|
      if saved_search = SavedSearch.find_by_score(current_user.id, params["score"])
        if saved_search.destroy
          format.json { render :json=>true }
          format.html { redirect_to saved_search_results_user_path(current_user) }
        end
      end
      format.json { render :json => 'errors', :status => :unprocessable_entity }
      format.html { redirect_to saved_search_results_user_path(current_user) }
    end
  end

end