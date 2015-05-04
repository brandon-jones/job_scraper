# lib/redis_instance_model.rb
module RedisInstanceModel

  def add(saved_search_id, data, passed_score = nil)
    contains = false
    if passed_score
      contains = contains_by_score?(saved_search_id, passed_score)
    end
    if contains == false || contains == nil
      contains = contains_by_member?(saved_search_id, data)
    end

    if contains == false || contains == nil
      score = passed_score || self.score
      data["score"] = score.to_s
      $redis.zadd("#{key}:#{saved_search_id}", score.to_f, data.to_json)
      return true
    end
    return false
  end

  def contains_by_score?(saved_search_id, passed_score)
    return false unless passed_score
    return $redis.zrangebyscore("#{key}:#{saved_search_id}",passed_score.to_f, passed_score.to_f).first
  end

  def contains_by_member?(saved_search_id, member)
    return false unless member
    all = get_current(saved_search_id)
    all.each do |checking|
      if checking.except(*unique_keys).to_hash == member
        return checking.score
      end
    end
    return false
  end

  def find_by_member(current_user, saved_search)
    all = get_current(saved_search["saved_search_id"])
    all.each do |member|
      if member.except(*unique_keys).to_hash == saved_search.except(*unique_keys).to_hash
        binding.pry
        return saved_search
      end
    end
    return false
  end

  def remove_by_score(saved_search_id, score)
    return $redis.zremrangebyscore("#{key}:#{saved_search_id}",score.to_f,score.to_f)
  end
end