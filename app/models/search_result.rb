class SearchResult < Hashie::Mash

  KEY = "search_results"

  TIME_TO_LIVE = 7.days

  def date
    return self.type.constantize.convert_date(self.date_str)
  end

  def self.add(saved_search_id, data, passed_score = nil)
    contains = false
    if passed_score
      contains = contains_by_score?(saved_search_id, passed_score)
    end
    if contains == false || contains == nil
      contains = contains_by_member?(saved_search_id, data)
    end

    if contains == false || contains == nil
      score = passed_score || Time.now.utc.to_f
      data["score"] = score.to_s
      $redis.zadd("#{KEY}:#{saved_search_id}", score.to_f, data.to_json)
      return true
    end
    return false
  end

  def self.contains_by_score?(saved_search_id, passed_score)
    return false unless passed_score
    return  $redis.zrangebyscore("#{KEY}:#{saved_search_id}",passed_score.to_f, passed_score.to_f).first
  end

  def self.contains_by_member?(saved_search_id, member)
    return false unless member
    all = get_current(saved_search_id)
    all.each do |checking|
      if checking.except("score", "applied").to_hash == member
        return checking.score
      end
    end
    return false
  end

  def self.get_current(saved_search_id)
    members = $redis.zrangebyscore("#{KEY}:#{saved_search_id}", (Time.now.utc - TIME_TO_LIVE).to_f, Time.now.utc.to_f)
    builder = []
    members.each do |member|
      builder << SearchResult.new(JSON.parse(member))
    end
    return builder
  end

  def self.remove_outdated(saved_search_id)
    $redis.zremrangebyscore("#{KEY}:#{saved_search_id}", -1, (Time.now.utc - TIME_TO_LIVE.to_f).to_f)
  end

  def self.remove_by_score(saved_search_id, score)
    return $redis.zremrangebyscore("#{KEY}:#{saved_search_id}",score.to_f,score.to_f)
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

   def self.find_by_member(current_user, saved_search)
    all = get_current(saved_search["saved_search_id"])
    all.each do |member|
      if member.except("applied").to_hash == saved_search.except("saved_search_id").to_hash
        return SearchResult.new(saved_search)
      end
    end
    return false
  end

end
