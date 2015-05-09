class SavedSearchResultsController < ApplicationController

  def updated
    redirect_to root_url and return unless current_user
    respond_to do |format|
      if ssr = SavedSearchResult.find_by_score(current_user.id, params["saved_search_result"]["score"].to_f)
        if ssr.add_key_value('updated', DateTime.now.utc.to_f.to_s, 'build')
          format.json { render :json=>{ id: params["saved_search_result"]["id"], link: params["saved_search_result"]["link"], company: ssr.company } }
        else
          format.json { render :json => 'errors', :status => :unprocessable_entity }
        end
      end
      format.json { render :json => 'errors', :status => :unprocessable_entity }
    end
  end

  def denied
    redirect_to root_url and return unless current_user
    respond_to do |format|
      if ssr = SavedSearchResult.find_by_score(current_user.id, params["saved_search_result"]["score"])
        if ssr.add_key_value('denied', DateTime.now.utc.to_f.to_s, 'override')
          format.json { render :json=>{ id: params["saved_search_result"]["id"], link: params["saved_search_result"]["link"], company: ssr.company } }
        else
          format.json { render :json => 'errors', :status => :unprocessable_entity }
        end
      end
      format.json { render :json => 'errors', :status => :unprocessable_entity }
    end
  end

  def add_key
    binding.pryparam
  end

  def update_link
    redirect_to root_url and return unless current_user
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
    redirect_to root_url and return unless current_user
    respond_to do |format|
      if model = SavedSearchResult.find_by_score(current_user.id, params["score"])
        if model.destroy
          sr = SearchResult.find_by_score(model.parent_unique_id, params["score"])
          if sr.add_key_value('deleted', DateTime.now.utc.to_f.to_s, 'override')
            format.json { render :json=>true }
            format.html { redirect_to saved_search_results_user_path(current_user) }
          else
            format.json { render :json => 'errors', :status => :unprocessable_entity }
          end
        end
      end
      format.html { redirect_to saved_search_results_user_path(current_user) }
      format.json { render :json => 'errors', :status => :unprocessable_entity }
    end
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