module RayBot
  module Commands
    class Blah < SlackRubyBot::Commands::Base
      command 'blah' do |client, data, match|
        client.say(channel: data.channel, text: 'boop')
      end
    end
  end
end
