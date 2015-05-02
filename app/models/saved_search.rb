class SavedSearch < Hashie::Mash

  KEY = 'saved_searches'

  def key
    return KEY
  end

  def add_result(result)
    SearchResult.add(self.saved_search_id, result)
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
      data[KEY] = data['we_work_remotely']
      if data[KEY].keys.include?('search_terms')
        data[KEY]['search_terms'] = data[KEY]['search_terms'].downcase
      end
      return data.except('we_work_remotely').to_hash
    end
  end

  def self.add(current_user, data)
    if data.class.to_s == 'String'
      data = JSON.parse(data)
    end
    data['user_id'] = current_user.id.to_s
    unless all(current_user).collect { |c| c.except('saved_search_id').to_json }.include?(data.to_json)
      data['saved_search_id'] = SecureRandom.hex(12)
      $redis.sadd("#{KEY}:#{current_user.id}", data.to_json)
    else
      puts 'ALREADY THERE' * 80
    end
    return self
  end

  def remove(current_user, member)
    $redis.sremove("#{KEY}:#{current_user.id}", member)
    return self
  end

  def all(current_user)
    builder = []
    members = $redis.smembers("#{KEY}:#{current_user.id}")
    members.each do |member|
      ss = SavedSearch.new(JSON.parse(member))
      builder << ss
    end
    return builder
  end

  def self.all(current_user)
    builder = []
    members = $redis.smembers("#{KEY}:#{current_user.id}")
    members.each do |member|
      ss = SavedSearch.new(JSON.parse(member))
      builder << ss
    end
    return builder
  end
end
