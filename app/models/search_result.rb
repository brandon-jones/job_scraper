class SearchResult < RedisModel

  TIME_TO_LIVE = 7.days

  def initialize(unique, hash = {})
    @unique_id = unique
    super(hash)
  end

  def date
    return self.type.constantize.convert_date(self.date_str)
  end

  def self.unique_keys
    return @unique_keys ||= [ "score", "applied", "saved_search_id", "parent_unique_id", "deleted" ]
  end

  def self.score
    return DateTime.now.utc.to_f.to_s
  end

  def self.key
    return @key ||= "search_results"
  end

  def self.get_current(saved_search_id)
    members = $redis.zrangebyscore("#{key}:#{saved_search_id}", (DateTime.now.utc - TIME_TO_LIVE).to_f, DateTime.now.utc.to_f)
    builder = []
    members.each do |member|
      builder << SearchResult.new(saved_search_id,JSON.parse(member))
    end
    return builder
  end

  def self.all(unique_id)
    @unique_id = unique_id
    return get_current(@unique_id)
  end

  def self.remove_outdated(saved_search_id)
    $redis.zremrangebyscore("#{key}:#{saved_search_id}", -1, (DateTime.now.utc - TIME_TO_LIVE.to_f).to_f)
  end

  # def add_applied_key(user, saved_search)
  #   SearchResult.new(saved_search["saved_search_id"]).remove_by_score(saved_search["score"])
  #   self["applied"] = true
  #   SearchResult.new(aved_search_id).add(self.except("saved_search_id"),saved_search.to_hash)
  # end

  # def self.add_deleted_key(user, saved_search_score)
  #   binding.pry
  # end

  def self.applied_to_job(current_user_id, saved_search)
    if job = self.find_by_member(saved_search['saved_search_id'], saved_search)
      if new_job = job.add_key_value('applied', DateTime.now.utc.to_f.to_s, 'override')
        return new_job
      else
        return false
      end
    end
    return false
  end
end
