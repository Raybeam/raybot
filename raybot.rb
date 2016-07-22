require 'slack-ruby-bot'
require 'raybot/bot'
Dir["raybot/commands/*.rb"].each {|f| require f}
