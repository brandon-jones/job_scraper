class JobSearchesController < ApplicationController

  def index
    @job_searches = JobSearch.all
  end

end