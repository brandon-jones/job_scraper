class SavedSearchResultsController < ApplicationController

  def update_link
    respond_to do |format|
      if ssr = SavedSearchResult.contains_by_score?(current_user.id, params["id"].to_f)
        SavedSearchResult.remove_by_score(current_user.id, params["id"])
        ssr.user_link = params["link"]
        if SavedSearchResult.add(current_user.id, ssr, ssr.score)
          format.json { render :json=>{ id: params["id"], link: params["link"], company: ssr.company } }
        else
          format.json { render :json => 'errors', :status => :unprocessable_entity }
        end
      end
      format.json { render :json => 'errors', :status => :unprocessable_entity }
    end
  end

  def index
    return [] unless current_user
    @saved_search_result = current_user.saved_search_results
  end

  def create
    redirect_to root_url and return unless current_user
    respond_to do |format|
      if SavedSearchResult.add(current_user.id, params["saved_search"].except('saved_search_id'))
        if SearchResult.applied_to_job(current_user.id,params["saved_search"])
          format.json { render :json=>true }
        else
          SavedSearchResult.remove(current_user.id, params["saved_search"].except('saved_search_id'))
          format.json { render :json => 'errors', :status => :unprocessable_entity }
        end
      else
        SavedSearchResult.remove(current_user.id, params["saved_search"].except('saved_search_id'))
        format.json { render :json => 'errors', :status => :unprocessable_entity }
      end
    end
  end

end