class SearchResults < Hashie::Mash

  KEY = "search_results"

  TIME_TO_LIVE = 7.days

  def self.add(saved_search_id, data)
    $redis.zadd("#{KEY}:#{saved_search_id}", Time.now.utc.to_i, data.to_json)
    return true
  end

  def self.get_current(saved_search_id)
    members = $redis.zrangebyscore("#{KEY}:#{saved_search_id}", (Time.now.utc - TIME_TO_LIVE).to_i, Time.now.utc.to_i)
    builder = []
    members.each do |member|
      builder << SearchResults.new(JSON.parse(member))
    end
    return builder
  end

  def self.remove_outdated(saved_search_id)
    $redis.zremrangebyscore("#{KEY}:#{saved_search_id}", -1, (Time.now.utc - TIME_TO_LIVE).to_i)
  end
end
