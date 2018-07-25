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
  class Dog
    def self.breeds
      uri = URI("https://dog.ceo/api/breeds/list/all")
      response = JSON.parse(Net::HTTP.get(uri))
      all_breeds = response['message']
      result = []
      for breed, subs in all_breeds do
        result.push(breed)
        for sub in subs do
          result.push("#{sub} #{breed}")
        end
      end
      result.sort
    end

    def self.random(breed)
      if breed.empty?
        return
      end
      url = "https://dog.ceo/api/breed/#{breed.strip.split.reverse.join('/')}/images/random"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      begin
        response = JSON.parse(response)
      rescue
        response = {'status' => 'error', 'message' => response}
      end
      if response['status'] == 'error'
        less = breed.split[1..-1].join(' ')
        Dog.random(less)
      else
        response['message']
      end
    end
  end
  module Commands
    class DogCommands < SlackRubyBot::Commands::Base
      match (/^(?<breed>[a-zA-Z ]+) me$/) do |client, data, match|
        client.say(channel: data.channel, text: Dog.random(match[:breed]))
      end

      match (/^(?<breed>[a-zA-Z ]+) bomb (?<count>\d+)$/) do |client, data, match|
        count = [match[:count].to_i, 5].min
        count.times do
          client.say(channel: data.channel, text: Dog.random(match[:breed]))
        end
      end

      match (/what breeds are there/i) do |client, data, match|
        client.web_client.chat_postMessage(
          channel: data.channel,
          as_user: true,
          attachments: [{
            fallback: Dog.breeds.join("\n"),
            title: "Dog breeds",
            text: Dog.breeds.join("\n"),
          }]
      )
      end
    end
  end
end
