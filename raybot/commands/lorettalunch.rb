require "net/http"
require "redis"

module RayBot
  module Commands
    class LorettaLunch < SlackRubyBot::Commands::Base
      include Samaya

      SPECIALS_URL = "http://lorettarestaurant.com/specials/?C=M;O=D"

      channel = data.channel

      match (/^.*(lorettalunch).*$/) do |client, data, match|
        redis = Redis.new(url: ENV['REDISTOGO_URL'])
        k = "loretta-lunch-" + self.date

        # Exit if the URL has already been found.
        break if redis.get(k)

        meal_event = self.todays_meal_event
        break unless meal_event["restaurant"] == "Loretta"

        special_url = self.loretta_lunch_special_today_url
        break unless special_url && special_url.length

        client.say(channel: self.channel, text: meal_url)
        redis.set(k, meal_url)
      end

      private
        def loretta_specials
          special_uri = URI.parse(specials_url)
          special_http = Net::HTTP.new(special_uri.host, special_uri.port)
          special_request = Net::HTTP::Get.new(special_uri.request_uri)
          special_response = special_http.request(special_request)
          special_response.body.split("<tr>")
        end

        def loretta_lunch_special_today_url
          todays_lunch_specials = self.loretta_specials.select do |special|
            (special.include? self.date) && (special.downcase.include? "lunch")
          end
          unless todays_lunch_specials && todays_lunch_specials.length == 1
            return ""
          end
          special = todays_lunch_specials[0]
          "http://lorettarestaurant.com/specials/" + special.match('(?<=<a href=\")[^"]+(?=\")')[0]
        end
    end
  end
end
