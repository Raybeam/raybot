require "net/http"
require "raybot/modules/samaya"

module RayBot
  module Commands
    class WhatDidIOrder < SlackRubyBot::Commands::Base
      match (/^.*(whatdidiorder).*$/) do |client, data, match|
        samaya = Samaya.new

        name = client.store.users[data.user]["profile"]["last_name"]
        break unless name

        meal_event = samaya.todays_meal_event
        unless meal_event
          client.say(channel: data.channel, text: "There is no lunch for today!")
          return
        end

        order_status = samaya.get_order_status_for_name(meal_event, name)
        if order_status == "ooo"
          client.say(channel: data.channel, text: "You are OOO today.")
          return
        elsif order_status == "pending"
          client.say(channel: data.channel, text: "You haven't decided yet.")
          return
        elsif order_status == "passed"
          client.say(channel: data.channel, text: "You passed on lunch today.")
          return
        else
          client.say(channel: data.channel, text: "Couldn't find an order status for you.")
          client.say(channel: data.channel, text: "Does your slack account last name match your last name in Samaya?")
          return
        end

        order = samaya.get_final_order_for_name(meal_event, name)
        if order.include?("\n")
          order = "```" + order + "```"
        end

        client.say(channel: data.channel, text: order)
      end
    end
  end
end
