if Rails.env == 'test'
  require 'mock_redis'
  $redis = MockRedis.new
elsif ENV["REDISCLOUD_URL"]
  $redis = Redis.new(:url => ENV["REDISCLOUD_URL"])
else
  $redis = Redis.new(:host => 'localhost', :port => 6379)
end