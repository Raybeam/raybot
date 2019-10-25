require "net/http"
require "redis"

module RayBot
  module Commands
    class LorettaLunch < SlackRubyBot::Commands::Base
      match (/^.*(lorettalunch).*$/) do |client, data, match|
        redis = Redis.new(url: ENV['REDISTOGO_URL'])
        base_url = "http://samaya.raybeam.com/meal_events/lunch_list?end=2000-01-01&start="
        date = Time.now.strftime("%Y-%m-%d")
        k = "lorettalunch:" + date
        client.say(channel: data.channel, text: k)

        # Exit if the URL has already been found.
        break if redis.get(k)

        meal_uri = URI.parse(base_url + date)
        meal_http = Net::HTTP.new(meal_uri.host, meal_uri.port)
        meal_request = Net::HTTP::Get.new(meal_uri.request_uri)
        meal_response = meal_http.request(meal_request)
        meals = JSON.parse(meal_response.body)

        specials_url = "http://lorettarestaurant.com/specials/?C=M;O=D"

        special_uri = URI.parse(specials_url)
        special_http = Net::HTTP.new(special_uri.host, special_uri.port)
        special_request = Net::HTTP::Get.new(special_uri.request_uri)
        special_response = special_http.request(special_request)
        specials = special_response.body.split("<tr>")

        meal_url = "Loretta isn't for lunch today!"
        for meal in meals
          if meal["start"] == date and meal["restaurant"] == "Loretta"
            meal_url = "Today's specials are not yet posted."
            for special in specials
              if special.include? date and special.downcase.include? "lunch"
                meal_url = "http://lorettarestaurant.com/specials/" + special.match('(?<=<a href=\")[^"]+(?=\")')[0]
                redis.set(k, meal_url)
              end
            end
          end
        end

        client.say(channel: data.channel, text: meal_url)
      end
    end
  end
end
