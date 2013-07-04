require 'ostruct'
require 'redis'
require 'httparty'

$redis = Redis.connect(url: ENV['REDISCLOUD_URL'] || "redis://localhost:6379")

def every(freq, klass, params)
  Clockwork.every(freq, "{ \"worker\": \"#{klass}\", \"params\": #{JSON.dump(params)} }")
end

module Clockwork
  handler do |element|
    result = JSON.parse(element, symbolize_names: true)
    Object.const_get(result[:worker]).perform_async(result[:params])
    # Object.const_get(result[:worker]).new.perform(result[:params])
  end
end

module App
  Settings = OpenStruct.new({
  })

  module Base

    def enqueue(id, h)
      $redis.publish "aerodrome", { id: id, body: h }.to_json
    end

  end
end
