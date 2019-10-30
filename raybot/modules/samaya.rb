require "net/http"

module RayBot
  class Samaya

    BASE_URL = "http://samaya.raybeam.com/"

    def date
      Time.now.strftime("%Y-%m-%d")
    end

    def todays_meal_event
      events_today = meal_events.select do |meal|
        meal["start"] == date
      end
      if events_today && events_today.length > 0
        return events_today[0]
      end
    end

    def get_html_for_meal_event(meal_event)
      event_url = BASE_URL + meal_event["url"]
      event_uri = URI.parse(event_url)
      event_http = Net::HTTP.new(event_uri.host, event_uri.port)
      event_request = Net::HTTP::Get.new(event_uri.request_uri)
      event_response = event_http.request(event_request)
      event_response.body.delete("\n")
    end

    def get_meal_event_url(meal_event)
      BASE_URL + meal_event["url"]
    end

    def get_picker(html)
      html.match('<span class="resource">(((?!span).)*)</span>')[1]
    end

    def get_waiting_on(html)
      order_status = get_order_status(html)
      pending_orders = order_status.split("<td>").select do |order|
        (order.include? "first pending") && (not order.include? "Dong Soo Anderson-Song")
      end
      pending_orders.map do |pending_order|
        pending_order.match('<a href=[^>]*>([^<]*)<')[1]
      end
    end

    def index_url
      BASE_URL + "meal_events/lunch_list?end=2000-01-01&start=" + date
    end

    def meal_events
      meal_uri = URI.parse(index_url)
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
