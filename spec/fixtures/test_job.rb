require 'sneakers'
require 'redis'

redis_addr = compose_or_localhost('redis')
puts "REDIS is at #{redis_addr}"
$redis = Redis.new(host: redis_addr)


class TestJob < ActiveJob::Base
  def perform(message)
    $redis.incr('rails_active_job')
  end
end
