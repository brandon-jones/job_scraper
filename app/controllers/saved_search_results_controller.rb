class SavedSearchResultsController < ApplicationController

  def update_link
    respond_to do |format|
      if ssr = SavedSearchResult.find_by_score(current_user.id, params["id"].to_f)
        if ssr.add_user_link(params["link"])
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

  def destroy
    if model = params["controller"].singularize.camelize.constantize.find_by_score(current_user.id, params["score"])
      if model.destory(current_user)
        SavedSearch.add_key_value(current_user.id, 'delete', 'true', model)
      else
        binding.pry
      end 
    end
    redirect_to '/user/applied_jobs'
  end

  def create
    redirect_to root_url and return unless current_user
    respond_to do |format|
      ssr = SavedSearchResult.new(current_user)
      if ssr.add(params["saved_search"].except('saved_search_id'))
        if SearchResult.applied_to_job(current_user.id,params["saved_search"])
          format.json { render :json=>true }
        else
          SavedSearchResult.remove(current_user.id, params["saved_search"].except('saved_search_id'))
          format.json { render :json => 'errors', :status => :unprocessable_entity }
        end
      else
        binding.pry
        # ssr.destory
        # SavedSearchResult.remove(current_user.id, params["saved_search"].except('saved_search_id'))
        format.json { render :json => 'errors', :status => :unprocessable_entity }
      end
    end
  end

end