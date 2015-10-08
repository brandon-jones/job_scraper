class SavedSearchesController < ApplicationController
  before_action :authenticated
  before_action :authenticated_admin, except: [:redis_info]

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

  def redis_info
    @redis_info = SavedSearch.raw_redis_info
  end

  def del_redis_key
    respond_to do |format|
      if !params.include?('key')
        format.json { render :json=>false }
      elsif $redis.del(params['key'])
        format.json { render :json=>true }
      else
        format.json { render :json => 'errors', :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    redirect_to root_url and return unless current_user
    respond_to do |format|
      if saved_search = SavedSearch.find_by_score(current_user.id, params["score"])
        if saved_search.destroy(true)
          format.json { render :json=>true }
          format.html { redirect_to saved_searches_user_path(current_user) }
        end
      end
      format.json { render :json => 'errors', :status => :unprocessable_entity }
      format.html { redirect_to saved_searches_user_path(current_user) }
    end
  end

  def viewed
    respond_to do |format|
      if params["score"] && params["parent_unqiue_id"] && current_user
        sr = SearchResult.find_by_score(params["parent_unqiue_id"], params["score"])
        sr.add_key_value('viewed', DateTime.now.utc.to_f.to_s, 'override')
        format.json { render :json=>true }
      else
        format.json { render :json => 'errors', :status => :unprocessable_entity }
      end
    end
  end

  def refresh
    respond_to do |format|
      if params["score"] && params["parent_unique_id"]
        ss = SavedSearch.find_by_score(params["parent_unique_id"],params["score"])
        if ss.refresh
          format.json { render :json=>true }
        else
          format.json { render :json=>'No new jobs' }
        end
      end
      format.json { render :json => 'errors', :status => :unprocessable_entity }
    end
  end

end