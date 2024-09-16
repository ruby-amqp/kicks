require 'spec_helper'
require 'sneakers'
require 'sneakers/runner'
require 'rabbitmq/http/client'
require 'active_job'
require 'active_job/queue_adapters/sneakers_adapter'
require 'fixtures/test_job'

describe 'ActiveJob integration' do
  before :each do
    skip unless ENV['INTEGRATION']
    prepare
  end

  def integration_log(msg)
    puts msg if ENV['INTEGRATION_LOG']
  end

  def rmq_addr
    @rmq_addr ||= compose_or_localhost('rabbitmq')
  end

  def prepare
    ActiveJob::Base.queue_adapter = :sneakers

    Sneakers.clear!
    Sneakers.configure(amqp: "amqp://guest:guest@#{rmq_addr}:5672")
    Sneakers.logger.level = Logger::ERROR

    redis_addr = compose_or_localhost('redis')
    @redis = Redis.new(host: redis_addr)
    @redis.del('rails_active_job')
  end

  def wait_for_jobs_to_finish
    sleep 5
  end

  def start_active_job_workers
    integration_log 'starting ActiveJob workers.'
    runner = Sneakers::Runner.new([ActiveJob::QueueAdapters::SneakersAdapter::JobWrapper], {})

    pid = fork { runner.run }

    integration_log 'waiting for workers to stabilize (5s).'
    sleep 5

    yield if block_given?
  ensure
    Process.kill('TERM', pid) rescue nil
  end

  it 'runs jobs enqueued on a listening queue' do
    start_active_job_workers do
      TestJob.perform_later('Hello Rails!')
      wait_for_jobs_to_finish
      assert_equal @redis.get('rails_active_job').to_i, 1
    end
  end

  it 'scheduling jobs are not supported' do
    assert_raises NotImplementedError, 'This queueing backend does not support scheduling jobs.' do
      TestJob.set(wait: 1.second).perform_later('Say Hello to Rails later!')
    end
  end
end
