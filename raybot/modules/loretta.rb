require "net/http"

module RayBot
  class Loretta

    SPECIALS_URL = "http://lorettarestaurant.com/specials/?C=M;O=D"

    def date
      Time.now.strftime("%Y-%m-%d")
    end

    def specials
      special_uri = URI.parse(SPECIALS_URL)
      special_http = Net::HTTP.new(special_uri.host, special_uri.port)
      special_request = Net::HTTP::Get.new(special_uri.request_uri)
      special_response = special_http.request(special_request)
      special_response.body.split("<tr>")
    end

    def lunch_special_today_url
      todays_lunch_specials = specials.select do |special|
        (special.include? date) && (special.downcase.include? "lunch")
      end
      unless todays_lunch_specials && todays_lunch_specials.length > 0
        return ""
      end
      special = todays_lunch_specials[0]
      "http://lorettarestaurant.com/specials/" + special.match('(?<=<a href=\")[^"]+(?=\")')[0]
    end
  end
end
