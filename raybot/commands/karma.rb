require 'redis'

module RayBot
  class Karma
    attr_accessor :target

    def initialize(target)
      @target = target.strip.gsub(/^\(|\)$|^@/, '')
    end

    def positive!
      redis.incr key(:positive)
    end

    def negative!
      redis.incr key(:negative)
    end

    def report
      pos = redis.get(key(:positive)).to_i
      neg = redis.get(key(:negative)).to_i

      if [pos, neg] == [0, 0]
        "#{@target} has no karma."
      else
        "%s's karma is %d (%d++, %d--) +/- ratio: %.3f" % [
          @target,
          pos - neg,
          pos,
          neg,
          pos.to_f / neg.to_f
        ]
      end
    end

    private
    def key(type)
      "karma:#{@target.downcase.gsub(/[^a-z0-9_]+/,'_')}:#{type}"
    end

    def redis
      @redis ||= Redis.new(url: ENV['REDISTOGO_URL'])
    end
  end

  module Commands
    class KarmaCommands < SlackRubyBot::Commands::Base
      HELP = <<-HELPTEXT.gsub(/^\s*\|/, '')
        | This bot tracks karma (imaginary internet points).
        |
        | *Giving Karma*
        | To give positive karma to something, include `something++` anywhere in a message.
        | For negative karma, use `something--`.
        |
        | To include spaces, use parentheses: `(something with parentheses)++`.
        | Don't try to get too clever, though. Nested parentheses won't work.
        |
        | *Checking Karma*
        | To check karma, use the !karma command: `!karma something`
      HELPTEXT

      scan (/(\(.+?\)|@?\S+?)(\+{2,}|-{2,})/) do |client, data, matches|
        user_name = client.web_client.users_info(user: data.user).user.name
        matches.each do |target, modspec|
          karma = Karma.new(target)
          if karma.target == user_name
            client.say(channel: data.channel, text: "You can't give yourself karma. That's not how this works.")
          else
            operation = modspec[0]
            if operation == '+'
              karma.positive!
            elsif operation == '-'
              karma.negative!
            end
          end
        end
      end

      match (/^!karma\s+(?<target>.+)$/) do |client, data, match|
        karma = Karma.new(match['target'])
        client.say(channel: data.channel, text: karma.report)
      end

      match (/^!karma(|help)$/i) do |client, data, match|
        client.say(channel: data.channel, text: HELP)
      end
    end
  end
end
