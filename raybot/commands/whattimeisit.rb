require "redis"

module RayBot
  module Commands
    class WhatTimeIsIt < SlackRubyBot::Commands::Base
      match (/^(whattimeisit)|(.*([wW]hat(\s+.*)*\s+time(\s+.*)*\s+is(\s+.*)*\s+it).*)$/) do |client, data, match|
        redis = Redis.new(url: ENV['REDISTOGO_URL'])
        k = 'universal-time'
        rk = 'return-time'
        right = 'C7NNT5EVB'
        time = (redis.get(k)).to_i
        unless time
          time = 0
        end
        redis.set(k, (time + 1).to_s)

        time_to_go_to_the_post_office = (time % 51 == 0)
        still_at_the_post_office = (redis.get(rk) && redis.get(rk) > time)
        if time_to_go_to_the_post_office
          return_time = time + rand(20)
          redis.set(rk, return_time)
          post_office_message = "running to the post office - back at #{return_time}"
          client.say(channel: right, text: post_office_message)
        end

        break if still_at_the_post_office

        client.say(channel: data.channel, text: time)
      end
    end
  end
end
