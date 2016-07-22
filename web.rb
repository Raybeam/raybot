require 'sinatra/base'

module RayBot
  class Web < Sinatra::Base
    get '/' do
      "No."
    end
  end
end
