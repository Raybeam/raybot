require "net/http"
require "raybot/modules/samaya"

module RayBot
  module Commands
    class LunchShame < SlackRubyBot::Commands::Base
      match (/^.*(lunchshame).*$/) do |client, data, match|
        samaya = Samaya.new

        channel = data.channel
        meal_event = samaya.todays_meal_event
        unless meal_event
          client.say(channel: channel, text: "There is no lunch for today!")
          return
        end

        restaurant_name = meal_event["restaurant"] + " "
        event_url = samaya.get_meal_event_url(meal_event)
        html = samaya.get_html_for_meal_event(meal_event)
        picker = samaya.get_picker(html)
        waiting_on = samaya.get_waiting_on(html)

        client.say(channel: channel, text: picker + " is picking up " + restaurant_name + "today.")
        if waiting_on.empty?
          client.say(channel: channel, text: "All lunches are in!")
        else
          client.say(channel: channel, text: "WAITING ON: " + waiting_on.join(', '))
        end
        client.say(channel: channel, text: event_url)
      end
    end
  end
end
