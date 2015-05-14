class EmailQueue

  def key
    return @key ||= 'email_queue'
  end

  def self.all
    return $redis.smembers(self.new.key)
  end

  def self.add(id)
    return $redis.sadd(self.new.key, id.to_s)
  end

  def self.pop_all
    list = all
    destroy
    return list
  end

  def self.destroy
    return $redis.del(self.new.key)
  end

end
