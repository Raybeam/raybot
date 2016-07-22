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

module RayBot
  module Commands
    class Pugs < SlackRubyBot::Commands::Base
      match (/^pug me$/) do |client, data, match|
        uri = URI("http://pugme.herokuapp.com/random")
        response = JSON.parse(Net::HTTP.get(uri))
        client.say(channel: data.channel,
                   text: response['pug'])
      end
      match (/^pug bomb (?<count>\d+)$/) do |client, data, match|
        count = match[:count].to_i
        uri = URI("http://pugme.herokuapp.com/bomb?count=#{count}")
        response = JSON.parse(Net::HTTP.get(uri))
        response['pugs'].each do |pug|
          client.say(channel: data.channel,
                     text: pug)
        end
      end
      match (/how many pugs are there/i) do |client, data, match|
        uri = URI("http://pugme.herokuapp.com/count")
        response = JSON.parse(Net::HTTP.get(uri))
        client.say(channel: data.channel,
                   text: "There are #{response['pug_count']} pugs.")
      end
    end
  end
end
