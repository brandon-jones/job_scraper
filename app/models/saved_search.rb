class SavedSearch < RedisModel

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

  def self.unique_keys
    return @unique_keys ||= [ "saved_search_id", "score", "parent_unique_id", "viewed", "updated_last" ]
  end

  def self.score
    return DateTime.now.utc.to_f.to_s
  end

  def self.key
    return @key ||= "saved_searches"
  end

  def get_unique_keys
    return_hash = {}
    return_hash['saved_search_id'] = SecureRandom.hex(12).to_s
    return return_hash.merge(super)
  end

  def job_search
    return JobSearch.find_by_id(self.job_search_id) if self.job_search_id
    return nil
  end

  def results
    return SearchResult.get_current(self.saved_search_id)
  end

  def user_data
    return_hash = {}
    js = job_search
    js.headers.each do |header|
      clean_header = header.gsub(' ','_').downcase
      return_hash[clean_header] = js.send("get_#{clean_header}",self)
    end
    return return_hash
  end

  def self.clean_params(data)
    if data["we_work_remotely"]
      key = self.key
      data[key] = data['we_work_remotely']
      if data[key].keys.include?('search_terms')
        data[key]['search_terms'] = data[key]['search_terms'].downcase
      end
      return data.except('we_work_remotely').to_hash
    end
  end

  def destroy
    $redis.del("#{SearchResult.key}:#{self.saved_search_id}")
    super
  end

  def refresh
    return Scraper.scrape_saved_search(self)
  end

end
