require "net/http"

module RayBot
  module Commands
    class WhatDidIOrder < SlackRubyBot::Commands::Base
      match (/^.*(whatdidiorder).*$/) do |client, data, match|
      
        user_info = client.store.users[data.user]
        
        client.say(channel: data.channel, text: user_info)

        
        base_url = "http://samaya.raybeam.com/meal_events/lunch_list?end=2000-01-01&start="
        date = Time.now.strftime("%Y-%m-%d")

        meal_uri = URI.parse(base_url + date)
        meal_http = Net::HTTP.new(meal_uri.host, meal_uri.port)
        meal_request = Net::HTTP::Get.new(meal_uri.request_uri)
        meal_response = meal_http.request(meal_request)
        meals = JSON.parse(meal_response.body)

        waiting_on = []
        meal_today = false
        restaurant_name = ""
        my_name = data.user
        my_order = ""
        for meal in meals
          if meal["start"] == date
            meal_today = true
            restaurant_name = meal["restaurant"] + " "
            event_url = "http://samaya.raybeam.com" + meal["url"]
            event_uri = URI.parse(event_url)
            event_http = Net::HTTP.new(event_uri.host, event_uri.port)
            event_request = Net::HTTP::Get.new(event_uri.request_uri)
            event_response = meal_http.request(event_request)
            event_html = event_response.body.delete("\n")
            my_order = event_html.match("Finalized Orders.*" + my_name + ".*?<td>(.*?)</td>")[1]
          end
        end

        unless meal_today
          client.say(channel: data.channel, text: "There is no lunch for today!")
          return
        end
        
        unless my_order
          client.say(channel: data.channel, text: "Couldn't find an order for " + my_name + " for today.")
        end

        client.say(channel: data.channel, text: my_order)
      end
    end
  end
end
