# lib/redis_instance_model.rb
class RedisModel < Hashie::Mash

  def self.add(saved_search_id, data, passed_values = {})
    data = JSON.parse(data) if data.class.to_s == 'String'
    
    contains = false
    if passed_values.keys.count > 0
      contains = contains_by_score?(saved_search_id, passed_values['score'])
    end
    if contains == false || contains == nil
      contains = contains_by_member?(saved_search_id, data)
    end

    if contains == false || contains == nil
      score = passed_values['score'] || self.score
      data["score"] = score.to_s
      data = self.add_unique_keys(data)
      $redis.zadd("#{key}:#{saved_search_id}", score.to_f, data.to_json)
      return true
    end
    return false
  end

  def self.add_unique_keys(data)
    return data
  end

  def self.contains_by_score?(unique_id, passed_score)
    return false unless passed_score
    found = $redis.zrangebyscore("#{key}:#{unique_id}",passed_score.to_i, passed_score.to_i).first
    if found
      return self.new(JSON.parse(found))
    end
    return false
  end

  def self.contains_by_member?(saved_search_id, member)
    return false unless member
    all = all(saved_search_id)
    all.each do |checking|
      if checking.except(*unique_keys) == member.to_hash
        return checking.score
      end
    end
    return false
  end

  def self.add_key_value(current_user, key, value, over_ride = false)
    binding.pry
  end

  def self.remove_key_value(current_user, key, value)
    binding.pry
  end

  def self.find_by_member(current_user, saved_search)
    all = all(saved_search["saved_search_id"])
    all.each do |member|
      if member.except(*unique_keys) == saved_search.except(*unique_keys)
        return self.new saved_search
      end
    end
    return false
  end

  def self.remove_by_score(unique_id, score)
    return $redis.zremrangebyscore("#{key}:#{unique_id}",score.to_f,score.to_f)
  end

  def self.all(unique_id)
    builder = []
      members = $redis.zrange("#{key}:#{unique_id}", 0, -1)
      members.each do |member|
        ss = self.new(JSON.parse(member))
        builder << ss
      end
    return builder
  end

  def destroy_path
    return "destroy_#{self.class.to_s.underscore}s_url"
  end

  # def add_unique_keys(data)
  #   return data
  # end
end