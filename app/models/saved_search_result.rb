class SavedSearchResult < Hashie::Mash

  KEY = 'saved_search_result'

  def self.remove(user, member)
    binding.pry
  end

  def self.add(user, data)
    unless $redis.sismember("#{KEY}:#{user.id}", data.except("score", 'applied').to_json)
      data["date_applied"] = DateTime.now.utc
      return $redis.sadd("#{KEY}:#{user.id}", data.except("score", "applied").to_json)
    end
    return false
  end

  def remove_applied_key
    
  end

  def self.all(user)
    return $redis.smembers("#{KEY}:#{user.id}").collect { |member| SavedSearchResult.new(JSON.parse(member)) }
  end
end