# lib/redis_instance_model.rb
class RedisModel < Hashie::Mash

  attr_accessor :unique_id

  def redis_key
    key = self.class.key
    raise 'error' unless key
    id = @unique_id
    raise 'error' unless id

    return "#{key}:#{id}"
  end

  def self.redis_key
    raise 'error'
  end

  def add(data, passed_values = {})

    data = JSON.parse(data) if data.class.to_s == 'String'

    contains = false
    if passed_values.keys.count > 0
      contains = self.class.find_by_score(@unique_id, passed_values['score'])
    end
    if contains == false || contains == nil
      contains = self.class.find_by_member(@unique_id, data)
    end

    if contains == false || contains == nil
      # score = passed_values['score'] || self.class.score
      data = get_unique_keys.merge(data)
      if $redis.zadd("#{redis_key}", data['score'].to_f, data.to_json)
        return self.class.new(unique_id, data)
      else
        return false
      end
    end
    return false
  end

  def get_unique_keys
    return_hash = {}
    return_hash["score"] = self.class.score
    return_hash['parent_unique_id'] = unique_id.to_s
    return return_hash
  end

  def to_time(obj)
    return nil unless self[obj]
    return DateTime.strptime(self[obj], "%s")
  end

  def self.find_by_score(unique_id, passed_score)
    return false unless passed_score
    passed_score = passed_score.to_s
    score = passed_score.include?('.') ? passed_score.to_f : passed_score.to_i
    found = $redis.zrangebyscore("#{self.new(unique_id).redis_key}",score, score).first
    if found
      return self.new(unique_id, JSON.parse(found))
    end
    return false
  end

  def self.find_by_member(unique_id, member)
    return false unless member
    all = self.all unique_id
    all.each do |checking|
      checker = checking.to_s == 'Hash' ? checking : checking.to_hash
      if checker['score'] && member['score'] && (checker['score'] == member['score'])
        return checking
      elsif checker.except(*unique_keys) == member.except(*unique_keys).to_hash
        return checking
      end
    end
    return false
  end

  # override, ignore, build
  def add_key_value(key, value, status = 'ignore')
    case status
    when 'ignore'
      self[key] = value unless self[key]
    when 'override'
      self[key] = value
    when 'build'
      self[key] = [] unless self[key]
      self[key] << value
    end

    if destroy
      return add(self, self)
    else
      return false
    end
  end

  def remove_key_value(key, value)
    binding.pry
  end

  def html_score
    return self.score
  end

  def destroy
    return $redis.zremrangebyscore("#{redis_key}",score.to_f,score.to_f)
  end

  def self.remove_by_score(score)
    return $redis.zremrangebyscore("#{redis_key}",score.to_f,score.to_f)
  end

  def self.all(unique_id)
    @unique_id = unique_id
    builder = []
      members = $redis.zrange("#{self.new(unique_id).redis_key}", 0, -1)
      members.each do |member|
        ss = self.new(@unique_id, JSON.parse(member))
        builder << ss
      end
    return builder
  end

end