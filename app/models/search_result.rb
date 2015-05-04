class SearchResult < Hashie::Mash

  extend RedisInstanceModel

  TIME_TO_LIVE = 7.days

  def date
    return self.type.constantize.convert_date(self.date_str)
  end

  def self.unique_keys
    return @unique_keys ||= [ "score", "applied", "saved_search_id" ]
  end

  def self.score
    return Time.now.utc.to_f
  end

  def self.key
    return @key ||= "search_results"
  end

  def self.get_current(saved_search_id)
    members = $redis.zrangebyscore("#{key}:#{saved_search_id}", (Time.now.utc - TIME_TO_LIVE).to_f, Time.now.utc.to_f)
    builder = []
    members.each do |member|
      builder << SearchResult.new(JSON.parse(member))
    end
    return builder
  end

  def self.remove_outdated(saved_search_id)
    $redis.zremrangebyscore("#{key}:#{saved_search_id}", -1, (Time.now.utc - TIME_TO_LIVE.to_f).to_f)
  end

  def add_applied_key(user, saved_search)
    SearchResult.remove_by_score(saved_search["saved_search_id"], saved_search["score"])
    self["applied"] = true
    SearchResult.add(saved_search_id,self.except("saved_search_id"),saved_search["score"])
  end

  def self.applied_to_job(current_user, saved_search)
    if job = find_by_member(current_user, saved_search)
      job.add_applied_key(current_user,saved_search)
      return job
    end
    return false
  end
end
