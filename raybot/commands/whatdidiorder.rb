require "net/http"
require "raybot/modules/samaya"

module RayBot
  module Commands
    class WhatDidIOrder < SlackRubyBot::Commands::Base
      match (/^(whatdidiorder)|(.*([wW]hat(\s+.*)*\s+did(\s+.*)*\s+[iI](\s+.*)*\s+order).*)$/) do |client, data, match|

        samaya = Samaya.new
        channel = data.channel

        is_im_channel = false
        client.ims.each_key do |im_channel_id|
          is_im_channel = is_im_channel || (im_channel_id == data.channel)
        end
        break unless is_im_channel

        user_info = client.store.users[data.user]
        name = user_info["profile"]["last_name"]
        unless name && name.length > 0
          client.say(channel: channel, text: "Unable to find a last name associated with your slack account.")
          return
        end

        meal_event = samaya.todays_meal_event
        unless meal_event
          client.say(channel: channel, text: "There is no lunch for today!")
          return
        end

        order_status = samaya.get_order_status_for_name(meal_event, name)
        if order_status == "ooo"
          client.say(channel: channel, text: "You are OOO today.")
          return
        elsif order_status == "pending"
          client.say(channel: channel, text: "You haven't decided yet.")
          return
        elsif order_status == "passed"
          client.say(channel: channel, text: "You passed on lunch today.")
          return
        elsif order_status == "error" || order_status == "uninvited"
          client.say(channel: channel, text: "Couldn't find an order status for you.")
          client.say(channel: channel, text: "Does your slack account last name match your last name in Samaya?")
          return
        end

        order = samaya.get_final_order_for_name(meal_event, name)
        if order.include?("\n")
          order = "```" + order + "```"
        end

        client.say(channel: channel, text: order)
      end
    end
  end
end
