require 'spec_helper'
require 'gzip_helper'
require 'sneakers/content_encoding'

describe Sneakers::ContentEncoding do
  after do
    Sneakers::ContentEncoding.reset!
  end

  describe '.decode' do
    it 'uses the given decoder' do
      Sneakers::ContentEncoding.register(
        content_encoding: 'gzip',
        encoder: ->(_) {},
        decoder: ->(payload) { gzip_decompress(payload) },
      )

      Sneakers::ContentEncoding.decode(gzip_compress('foobar'), 'gzip').must_equal('foobar')
    end
  end

  describe '.encode' do
    it 'uses the given encoder' do
      Sneakers::ContentEncoding.register(
        content_encoding: 'gzip',
        encoder: ->(payload) { gzip_compress(payload) },
        decoder: ->(_) {},
      )

      gzip_decompress(Sneakers::ContentEncoding.encode('foobar', 'gzip')).must_equal('foobar')
    end

    it 'passes the payload through by default' do
      payload = "just some text"
      Sneakers::ContentEncoding.encode(payload, 'unknown/encoding').must_equal(payload)
      Sneakers::ContentEncoding.decode(payload, 'unknown/encoding').must_equal(payload)
      Sneakers::ContentEncoding.encode(payload, nil).must_equal(payload)
      Sneakers::ContentEncoding.decode(payload, nil).must_equal(payload)
    end

    it 'passes the payload through if type not found' do
      Sneakers::ContentEncoding.register(content_encoding: 'found/encoding', encoder: ->(_) {}, decoder: ->(_) {})
      payload = "just some text"

      Sneakers::ContentEncoding.encode(payload, 'unknown/encoding').must_equal(payload)
      Sneakers::ContentEncoding.decode(payload, 'unknown/encoding').must_equal(payload)
    end
  end

  describe '.register' do
    it 'provides a mechnism to register a given encoding' do
      Sneakers::ContentEncoding.register(
        content_encoding: 'gzip',
        encoder: ->(payload) { gzip_compress(payload) },
        decoder: ->(payload) { gzip_decompress(payload) },
      )

      ce = Sneakers::ContentEncoding
      ce.decode(ce.encode('hello world', 'gzip'), 'gzip').must_equal('hello world')
    end

    it 'requires a content encoding' do
      proc { Sneakers::ContentEncoding.register(encoder: -> { }, decoder: -> { }) }.must_raise ArgumentError
    end

    it 'expects encoder and decoder to be present' do
      proc { Sneakers::ContentEncoding.register(content_encoding: 'foo', decoder: -> { }) }.must_raise ArgumentError
      proc { Sneakers::ContentEncoding.register(content_encoding: 'foo', encoder: -> { }) }.must_raise ArgumentError
    end

    it 'expects encoder and decoder to be a proc' do
      proc { Sneakers::ContentEncoding.register(content_encoding: 'foo', encoder: 'not a proc', decoder: ->(_) { }) }.must_raise ArgumentError
      proc { Sneakers::ContentEncoding.register(content_encoding: 'foo', encoder: ->(_) {}, decoder: 'not a proc' ) }.must_raise ArgumentError
    end

    it 'expects encoder and deseridecoderalizer to have the correct arity' do
      proc { Sneakers::ContentEncoding.register(content_encoding: 'foo', encoder: ->(_,_) {}, decoder: ->(_) {}) }.must_raise ArgumentError
      proc { Sneakers::ContentEncoding.register(content_encoding: 'foo', encoder: ->(_) {}, decoder: ->() {} ) }.must_raise ArgumentError
    end
  end
end