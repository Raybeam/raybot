module RayBot
  module Commands
    class LorettaLunch < SlackRubyBot::Commands::Base
      command 'lorettalunch' do |client, data, match|
        client.say(channel: data.channel, text: 'Lunch Options')
      end
    end
  end
end
