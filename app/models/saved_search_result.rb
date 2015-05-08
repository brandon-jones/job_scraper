class SavedSearchResult < RedisModel

  def initialize(user, hash = {})
    case user.class.to_s
      when 'Fixnum'
        @unique_id = user.to_s
      when 'String'
        @unique_id = user
      when 'User'
        @unique_id = user.id
    end
    super(hash)
  end

  def self.key
    return @key ||= 'saved_search_results'
  end

   def self.unique_keys
    return @unique_keys ||= [ "user_link", "date_applied" ]
  end

  def self.score
    return SecureRandom.random_number.to_s
  end

  def get_unique_keys
    return_hash = {}
    return_hash["date_applied"] = DateTime.now.utc.to_s
    return return_hash.merge(super)
  end

  def add_user_link(link)
    add_key_value('user_link', link, true)
    if add_key_value('user_link', link, true)
      return self
    end
    return false
  end
end