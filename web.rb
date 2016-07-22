require 'sinatra/base'

module RayBot
  class Web < Sinatra::Base
    get '/' do
      'Hello!'
    end
  end
end
