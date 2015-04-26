class JobSearchesController < ApplicationController

  def index
    @job_searches = JobSearch.all
  end

  def we_work_remotely
    @job_search = params
  end

end