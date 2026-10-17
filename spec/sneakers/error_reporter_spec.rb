require 'spec_helper'
require 'sneakers'

describe Sneakers::ErrorReporter::DefaultLogger do
  it 'does not pass delivery_info, which references the Bunny channel, to the logger' do
    logged = []
    logger = Object.new
    logger.define_singleton_method(:warn) { |payload| logged << payload }
    logger.define_singleton_method(:error) { |_| }
    delivery_info = Object.new
    delivery_info.instance_variable_set(:@channel, delivery_info) # cyclic, like Bunny's channel/connection

    original = Sneakers.logger
    Sneakers.logger = logger
    begin
      Sneakers::ErrorReporter::DefaultLogger.new.call(
        RuntimeError.new('boom'), Object.new, log_msg: 'm', delivery_info: delivery_info, metadata: {}
      )
    ensure
      Sneakers.logger = original
    end

    _(logged).must_equal([{ log_msg: 'm', metadata: {} }])
  end
end
