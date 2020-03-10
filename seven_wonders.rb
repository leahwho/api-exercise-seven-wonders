require 'httparty'
require 'dotenv'

Dotenv.load

unless ENV["LOCATION_IQ_KEY"]
  puts "Could not load API key; please store in environment variable 'LOCATION_IQ_KEY'."
  exit
end

BASE_URL = "https://us1.locationiq.com/v1/search.php"
LOCATION_IQ_KEY = ENV["LOCATION_IQ_KEY"]


def get_location(search_term)   
  url = BASE_URL
  
  query = {
    "key" => LOCATION_IQ_KEY,
    "q" => search_term
  }
  
  response = HTTParty.get(url, query: query)
  location = {}
  
  if response['searchresults']['place'].class == Array
    location = {
      search_term => {
        :lat => response["searchresults"]["place"][0]["lat"], :lon=>response["searchresults"]["place"][0]["lon"]
      }
    }
  else location = {
    search_term => {
      :lat => response["searchresults"]["place"]["lat"], :lon=>response["searchresults"]["place"]["lon"]
    }
  } 
end

return location
end

def find_seven_wonders
  seven_wonders = ["Great Pyramid of Giza", "Gardens of Babylon", "Colossus of Rhodes", "Pharos of Alexandria", "Statue of Zeus at Olympia", "Temple of Artemis", "Mausoleum at Halicarnassus"]
  
  seven_wonders_locations = []
  
  seven_wonders.each do |wonder|
    sleep(0.5)
    seven_wonders_locations << get_location(wonder)
  end
  
  return seven_wonders_locations
end

the_wonders = find_seven_wonders

the_wonders.each do |wonder|
  wonder.map { |place, location| puts "The #{place} is located here: \n#{location}." }
end


# puts "#{find_seven_wonders}"


# Expecting something like:
# [{"Great Pyramid of Giza"=>{:lat=>"29.9791264", :lon=>"31.1342383751015"}}, {"Gardens of Babylon"=>{:lat=>"50.8241215", :lon=>"-0.1506162"}}, {"Colossus of Rhodes"=>{:lat=>"36.3397076", :lon=>"28.2003164"}}, {"Pharos of Alexandria"=>{:lat=>"30.94795585", :lon=>"29.5235626430011"}}, {"Statue of Zeus at Olympia"=>{:lat=>"37.6379088", :lon=>"21.6300063"}}, {"Temple of Artemis"=>{:lat=>"32.2818952", :lon=>"35.8908989553238"}}, {"Mausoleum at Halicarnassus"=>{:lat=>"37.03788265", :lon=>"27.4241455276707"}}]
