require "net/http"

module RayBot
  module Commands
    class LunchShame < SlackRubyBot::Commands::Base
      include RayBot::Commands::Samaya

      match (/^.*(lunchshame).*$/) do |client, data, match|
        channel = data.channel
        meal_event = self.todays_meal_event
        unless meal_event
          client.say(channel: channel, text: "There is no lunch for today!")
          return
        end

        restaurant_name = meal_event["restaurant"] + " "
        event_url = self.get_meal_event_url(meal_event)
        html = self.get_html_for_meal_event(meal_event)
        picker = self.get_picker(html)
        waiting_on = self.get_waiting_on(html)

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
