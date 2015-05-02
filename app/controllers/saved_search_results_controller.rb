class SavedSearchResultsController < ApplicationController

  def index
    return [] unless current_user
    @saved_search_result = current_user.saved_search_results
  end

  def create
    redirect_to root_url and return unless current_user
    respond_to do |format|
      if SavedSearchResult.add(current_user, params["saved_search"].except('saved_search_id'))
        if SearchResult.applied_to_job(current_user,params["saved_search"])
          format.json { render :json=>true }
        else
          SavedSearchResult.remove(current_user, params["saved_search"].except('saved_search_id'))
          format.json { render :json => 'errors', :status => :unprocessable_entity }
        end
      else
        SavedSearchResult.remove(current_user, params["saved_search"].except('saved_search_id'))
        format.json { render :json => 'errors', :status => :unprocessable_entity }
      end
    end
  end

end