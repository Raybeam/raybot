require "net/http"
require "redis"
require "raybot/modules/samaya"
require "raybot/modules/loretta"

module RayBot
  module Commands
    class LorettaLunch < SlackRubyBot::Commands::Base
      match (/^.*(lorettalunch).*$/) do |client, data, match|
        channel = "C1TUV5XFA"

        samaya = Samaya.new
        redis = Redis.new(url: ENV['REDISTOGO_URL'])
        loretta = Loretta.new

        k = "loretta-lunch-" + loretta.date
        break if redis.get(k)

        meal_event = samaya.todays_meal_event
        break unless meal_event["restaurant"] == "Loretta"

        special_url = loretta.lunch_special_today_url
        break unless special_url && special_url.length

        client.say(channel: channel, text: meal_url)
        redis.set(k, meal_url)
      end
    end
  end
end
