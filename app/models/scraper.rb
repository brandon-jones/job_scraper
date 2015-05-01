class Scraper
  def self.scrape_all
    users = User.all
    saved_searches = []
    users.each do |user|
      ss = SavedSearches.new
      ss_all = user.saved_searches
      saved_searches += ss_all if ss_all
    end

    saved_searches.uniq!

    saved_searches.each do |saved_search|

      job_search = JobSearch.find_by_id(saved_search.job_search_id)
      search_url = job_search.search_url

      saved_search.keys.each do |key|
        search_url = search_url.gsub("{{#{key}}}",saved_search.send(key))
      end

      response = fetch(search_url,3)

      search_results = job_search.build_search_results(saved_search,response.body)

      search_results.each do |search_result|
        saved_search.add_result(search_result)
      end

    end
  end

  def self.fetch(uri_str, limit = 10)
    response = Net::HTTP.get_response(URI(uri_str))

    case response
    when Net::HTTPSuccess then
      return response
    when Net::HTTPRedirection then
      location = response['location']
      warn "redirected to #{location}"
      return fetch(location, limit - 1) unless limit == 0
      return response
    else
      response.value
    end
  end

  def self.scrape_for_user(user_id)

  end

end