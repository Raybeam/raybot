require "redis"

module RayBot
  module Commands
    class WhatTimeIsIt < SlackRubyBot::Commands::Base
      match (/^(whattimeisit)|(.*([wW]hat(\s+.*)*\s+time(\s+.*)*\s+is(\s+.*)*\s+it).*)$/) do |client, data, match|
        redis = Redis.new(url: ENV['REDISTOGO_URL'])
        k = 'universal-time'
        time = redis.get(k) || 0
        redis.set(k, time + 1)
        client.say(channel: channel, text: time)
      end
    end
  end
end
