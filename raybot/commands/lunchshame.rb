require "net/http"

module RayBot
  module Commands
    class LunchShame < SlackRubyBot::Commands::Base
      match (/^.*(lunchshame).*$/) do |client, data, match|
        base_url = "http://samaya.raybeam.com/meal_events/lunch_list?end=2000-01-01&start="
        date = Time.now.strftime("%Y-%m-%d")

        meal_uri = URI.parse(base_url + date)
        meal_http = Net::HTTP.new(meal_uri.host, meal_uri.port)
        meal_request = Net::HTTP::Get.new(meal_uri.request_uri)
        meal_response = meal_http.request(meal_request)
        meals = JSON.parse(meal_response.body)

        waiting_on = []
        for meal in meals
          if meal["start"] == date
            event_uri = URI.parse("http://samaya.raybeam.com" + meal["url"])
            event_http = Net::HTTP.new(event_uri.host, event_uri.port)
            event_request = Net::HTTP::Get.new(event_uri.request_uri)
            event_response = meal_http.request(event_request)
            event_html = event_response.body.delete("\n")
            order_status = event_html.match("<table class='order-status'>((?!table).)*</table>")[0]
            for order in order_status.split("<td>")
              if order.include? "first pending"
                waiting_on.append(order.match('<a href=[^>]*>([^<]*)<')[1])
              end
            end
          end
        end

        client.say(channel: data.channel, text: "WAITING ON: " + waiting_on.join(', '))
      end
    end
  end
end
