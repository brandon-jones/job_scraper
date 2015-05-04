class SavedSearch < Hashie::Mash

  extend RedisInstanceModel

  def self.unique_keys
    return @unique_keys ||= [ "saved_search_id" ]
  end

  def self.score
    return SecureRandom.hex(12)
  end

  def self.key
    return @key ||= "saved_searches"
  end

  def key
    return @key ||= "saved_searches"
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
      data[self.key] = data['we_work_remotely']
      if data[self.key].keys.include?('search_terms')
        data[self.key]['search_terms'] = data[self.key]['search_terms'].downcase
      end
      return data.except('we_work_remotely').to_hash
    end
  end

  # def self.add(current_user, data)
  #   if data.class.to_s == 'String'
  #     data = JSON.parse(data)
  #   end
  #   data['user_id'] = current_user.id.to_s
  #   unless all(current_user).collect { |c| c.except('saved_search_id').to_json }.include?(data.to_json)
  #     data['saved_search_id'] = SecureRandom.hex(12)
  #     $redis.sadd("#{KEY}:#{current_user.id}", data.to_json)
  #   else
  #     puts 'ALREADY THERE' * 80
  #   end
  #   return self
  # end

  # def remove(current_user, member)
  #   $redis.sremove("#{key}:#{current_user.id}", member)
  #   return self
  # end

  def all(current_user)
    builder = []
    # if $redis.keys.include?("#{key}:#{current_user.id}")
      members = $redis.zrange("#{key}:#{current_user.id}", 0, -1)
      members.each do |member|
        ss = SavedSearch.new(JSON.parse(member))
        builder << ss
      end
    # end
    return builder
  end

  def self.all(current_user)
    builder = []
    # if $redis.keys.include?("#{key}:#{current_user.id}")
      members = $redis.zrange("#{key}:#{current_user.id}", 0, -1)
      members.each do |member|
        binding.pry
        ss = SavedSearch.new(JSON.parse(member))
        builder << ss
      end
    # end
    return builder
  end
end
