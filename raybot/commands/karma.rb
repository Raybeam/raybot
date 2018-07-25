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

    def message
      pos = redis.get(key(:positive)).to_i
      neg = redis.get(key(:negative)).to_i
      total = pos + neg
      karma_description = [
        'karma',
        'imaginary internet points',
        'warm fuzzy feelings',
        'coupons redeemable for 1g of ambient oxygen'
      ].sample

      if [pos, neg] == [0, 0]
        "no #{karma_description}."
      else
        "#{pos - neg} #{karma_description} (#{pos}++, #{neg}--)."
      end
    end

    def attachment
      pos = redis.get(key(:positive)).to_i
      neg = redis.get(key(:negative)).to_i
      total = pos + neg

      if [pos, neg] == [0, 0]
        {
          fallback: "#{@target} #{@message}",
          title: @target,
          text: "#{@target}  #{@message}.",
          color: '#888888'
        }
      else
        {
          fallback: "#{@target} has #{@message} (#{pos}++, #{neg}--).",
          title: "#{@target} has #{@message}",
          fields: [
            {
              title: 'Positive (++)',
              value: "%d (%.1f%%)" % [pos, (pos.to_f / total.to_f * 100)],
              short: true
            },
            {
              title: 'Negative (--)',
              value: "%d (%.1f%%)" % [neg, (neg.to_f / total.to_f * 100)],
              short: true
            }
          ],
          color: ((pos >= neg) ? 'good' : 'danger')
        }
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
              face = ":good-dog:"
            elsif operation == '-'
              karma.negative!
              face = ":brady:"
            end
            client.web_client.chat_postMessage(
              channel: data.channel,
              as_user: true,
              text: "#{karma.target} now has #{karma.message} #{face}",
            )
          end
        end
      end

      match (/^!karma\s+(?<target>.+)$/) do |client, data, match|
        karma = Karma.new(match['target'])
        client.web_client.chat_postMessage(
          channel: data.channel,
          as_user: true,
          attachments: [karma.attachment]
        )
      end

      match (/^!karma(|help)$/i) do |client, data, match|
        client.say(channel: data.channel, text: HELP)
      end
    end
  end
end
