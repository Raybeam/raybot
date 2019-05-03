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
      match (/^(?<name>.*) bomb (?<count>\d+)$/) do |client, data, match|
        count = [match[:count].to_i, 100].min
        count.times do
          client.say(channel: data.channel, text: 'Aloha ' + match[:name])
        end
      end
    end
  end
end
