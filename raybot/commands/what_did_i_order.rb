require "net/http"
require "raybot/modules/samaya"

module RayBot
  module Commands
    class WhatDidIOrder < SlackRubyBot::Commands::Base
      match (/^.*(whatdidiorder).*$/) do |client, data, match|
        samaya = Samaya.new

        my_name = client.store.users[data.user]["last_name"]
        break unless my_name

        meal_event = samaya.todays_meal_event
        unless meal_event
          client.say(channel: data.channel, text: "There is no lunch for today!")
          return
        end

        html = samaya.get_html_for_meal_event(meal_event)
        break unless html

        matches = html.match("Finalized Orders.*" + my_name + ".*?<td>(.*?)</td>")
        unless matches && matches.length > 0
          client.say(channel: data.channel, text: "Couldn't find an order for " + my_name + " for today.")
          client.say(channel: data.channel, text: "Does your slack account 'Full name' match your name in Samaya?")
          return
        end

        my_order = matches[1].gsub("&nbsp;", " ").gsub("\r<br />","\n")
        if my_order.include?("\n")
          my_order = "```" + my_order + "```"
        end

        client.say(channel: data.channel, text: my_order)
      end
    end
  end
end
