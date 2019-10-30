require "net/http"

module Raybot
  module Commands
    module Samaya
      extend self

      BASE_URL = "http://samaya.raybeam.com/"

      def date
        Time.now.strftime("%Y-%m-%d")
      end

      def todays_meal_event
        self.meal_events.filter do |meal|
          meal["start"] == self.date
        end
      end

      def get_html_for_meal_event(meal_event)
        event_url = self.BASE_URL + meal_event["url"]
        event_uri = URI.parse(event_url)
        event_request = Net::HTTP::Get.new(event_uri.request_uri)
        event_response = meal_http.request(event_request)
        event_response.body.delete("\n")
      end

      def get_meal_event_url(meal_event)
        self.BASE_URL + meal["url"]
      end

      def get_picker(html)
        html.match('<span class="resource">(((?!span).)*)</span>')[1]
      end

      def get_waiting_on(html)
        waiting_on = []
        order_status = self.get_order_status(html)
        for order in order_status.split("<td>")
          if (order.include? "first pending") && (not order.include? "Dong Soo Anderson-Song")
            waiting_on.append(order.match('<a href=[^>]*>([^<]*)<')[1])
          end
        end
      end

      private

        def index_url
          self.base_URL + "meal_events/lunch_list?end=2000-01-01&start=" + self.date
        end

        # Returns an array of objects with the keys:
        # start -> %Y-%m-%d timestamp
        # restaurant -> restaurant name
        # url -> event url
        def meal_events
          meal_uri = URI.parse(self.index_url)
          meal_http = Net::HTTP.new(meal_uri.host, meal_uri.port)
          meal_request = Net::HTTP::Get.new(meal_uri.request_uri)
          meal_response = meal_http.request(meal_request)
          JSON.parse(meal_response.body)
        end

        def get_order_status(html)
          html.match("<table class='order-status'>((?!table).)*</table>")[0]
        end
    end
  end
end
