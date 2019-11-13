require "redis"

module RayBot
  module Commands
    class WhatTimeIsIt < SlackRubyBot::Commands::Base
      match (/^(whattimeisit)|(.*([wW]hat(\s+.*)*\s+time(\s+.*)*\s+is(\s+.*)*\s+it).*)$/) do |client, data, match|
        redis = Redis.new(url: ENV['REDISTOGO_URL'])
        k = 'universal-time'
        time = (redis.get(k)).to_i
        unless time
          time = 0
        end
        redis.set(k, (time + 1).to_s)
        client.say(channel: data.channel, text: time)
      end
    end
  end
end
