# Description:
#   Pugme is the most important thing in your life
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   pug me - Receive a pug
#   pug bomb N - get N pugs
require 'net/http'
require 'json'
require 'redis'

module RayBot
  module Commands
    class AtmeCommands < SlackRubyBot::Commands::Base
      match (/^mike me$/) do |client, data, match|
        client.say(channel: data.channel, text: '@Mike H')
      end

      match (/^mike bomb (?<count>\d+)$/) do |client, data, match|
        count = [match[:count].to_i, 100].min
        count.times do
          client.say(channel: data.channel, text: 'aloha @Mike H')
        end
      end
    end
  end
end
