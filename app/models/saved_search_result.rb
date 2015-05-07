class SavedSearchResult < RedisModel

  def self.key
    return @key ||= 'saved_search_results'
  end

   def self.unique_keys
    return @unique_keys ||= [ "user_link" ]
  end

  def self.score
    return SecureRandom.random_number(1000000)
  end

  def self.add_unique_keys(data)
    data["date_applied"] = DateTime.now.utc
    return data
  end
end