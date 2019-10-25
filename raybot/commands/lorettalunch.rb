require "net/http"

module RayBot
  module Commands
    class LorettaLunch < SlackRubyBot::Commands::Base
      command 'lorettalunch' do |client, data, match|
        base_url = "http://samaya.raybeam.com/meal_events/lunch_list?end=2000-01-01&start="
        date = Time.now.strftime("%Y-%m-%d")

        meal_uri = URI.parse(base_url + date)
        meal_http = Net::HTTP.new(uri.host, uri.port)
        meal_request = Net::HTTP::Get.new(uri.request_uri)
        meal_response = http.request(request)
        meals = JSON.parse(response.body)

        specials_url = "http://lorettarestaurant.com/specials/?C=M;O=D"

        special_uri = URI.parse(specials_url)
        special_http = Net::HTTP.new(uri.host, uri.port)
        special_request = Net::HTTP::Get.new(uri.request_uri)
        special_response = http.request(request)
        specials = response.body.split("</tr>
        <tr>")

        meal_url = "Loretta isn't for lunch today!"
        for meal in meals
          if meal["start"] == date
            for special in specials
              if special.include? date and special.downcase.include? "lunch"
                meal_url = "http://lorettarestaurant.com/specials/" + special.match('(?<=<a href=\")[^"]+(?=\")')[0]
              end
            end
          end
        end

        client.say(channel: data.channel, text: meal_url)
      end
    end
  end
end
