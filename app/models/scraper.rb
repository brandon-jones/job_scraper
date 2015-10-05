class Scraper
  require 'net/http'
  
  # while being more efficent i needed a way to track user ids
  # def self.scrape_all
  #   users = User.all
  #   saved_searches = []
  #   users.each do |user|
  #     ss = SavedSearch.new(user)
  #     ss_all = user.saved_searches
  #     saved_searches += ss_all if ss_all
  #   end

  #   saved_searches.uniq!

  #   saved_searches.each do |saved_search|


  #     job_search = JobSearch.find_by_id(saved_search.job_search)
  #     search_url = job_search.search_url

  #     saved_search.keys.each do |key|
  #       search_url = search_url.gsub("{{#{key}}}",saved_search.send(key).to_s)
  #     end


  #     response = fetch(search_url,3)

  #     search_results = job_search.build_search_results(saved_search,response.body)

  #     search_results.each do |search_result|
  #       sr = SearchResult.new(saved_search.saved_search_id)
  #       sr.add(search_result)
  #       # saved_search.add_result(search_result)
  #     end

  #   end
  # end

  def self.scrape_all
    users = User.all
    user_ids = []
    saved_searches = []
    users.each do |user|
      user_ids << scrape_user(user)
    end
    return user_ids.uniq
  end

  def self.scrape_user(user)
    return false unless user
    user = User.find_by_id(user_id) if user.class.to_s == 'String'

    added = false

    user.saved_searches.each do |saved_search|
      added = true if scrape_saved_search(saved_search)
    end

    return user.id if added
    return false
  end

  def self.scrape_saved_search(saved_search)

    saved_search.add_key_value('updated_last', DateTime.now.utc.to_f.to_s, 'override')

    job_search = saved_search.job_search
    search_url = job_search.search_url

    saved_search.keys.each do |key|
      search_url = search_url.gsub("{{#{key}}}",saved_search.send(key).to_s)
    end

    response = fetch(URI.escape(search_url),3)

    search_results = job_search.build_search_results(saved_search,response.body)

    added = false

    search_results.each do |search_result|
      sr = SearchResult.new(saved_search.saved_search_id)
      added = true if sr.add(search_result)
    end
    return added
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

end