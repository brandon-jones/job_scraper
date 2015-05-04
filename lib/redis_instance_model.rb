# lib/redis_instance_model.rb
module RedisInstanceModel

  def add(saved_search_id, data, passed_score = nil)
    data = JSON.parse(data) if data.class.to_s == 'String'
    
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
      data = self.add_unique_keys(data)
      $redis.zadd("#{key}:#{saved_search_id}", score.to_f, data.to_json)
      return true
    end
    return false
  end

  def add_unique_keys(data)
    return data
  end

  def contains_by_score?(unique_id, passed_score)
    return false unless passed_score
    found = $redis.zrangebyscore("#{key}:#{unique_id}",passed_score.to_f, passed_score.to_f).first
    if found
      return self.new(JSON.parse(found))
    end
    return false
  end

  def contains_by_member?(saved_search_id, member)
    return false unless member
    all = all(saved_search_id)
    all.each do |checking|
      if checking.except(*unique_keys) == member.to_hash
        return checking.score
      end
    end
    return false
  end

  def find_by_member(current_user, saved_search)
    all = all(saved_search["saved_search_id"])
    all.each do |member|
      if member.except(*unique_keys) == saved_search.except(*unique_keys)
        return self.new saved_search
      end
    end
    return false
  end

  def remove_by_score(unique_id, score)
    return $redis.zremrangebyscore("#{key}:#{unique_id}",score.to_f,score.to_f)
  end

  def all(unique_id)
    builder = []
      members = $redis.zrange("#{key}:#{unique_id}", 0, -1)
      members.each do |member|
        ss = self.new(JSON.parse(member))
        builder << ss
      end
    return builder
  end

  # def add_unique_keys(data)
  #   return data
  # end
end