#!/usr/bin/env ruby

require 'mechanize'
#require 'json'
require 'scraperwiki'

ScraperWiki.config = { db: 'data.sqlite', default_table_name: 'data' }

mechanize = Mechanize.new
mechanize.user_agent_alias = 'Mac Safari'
puts "Fetching Main Page ...\n"
page = mechanize.get('http://rnli.org/aboutus/lifeboatsandstations/stations/Pages/Stations-a-z.aspx')

puts "Finding Station Links\n"
station_links = page.links_with(href: %r{^\/findmynearest\/station\/Pages\/.*})
puts "Number of Station Links => #{station_links.length}"

#station_links = station_links[0...4]
#puts "Selecting #{station_links.count} stations\n"

stations = station_links.map.with_index do |link, index|
  puts "#{index+1} - #{link}"
  station = link.click
  station_name = station.search('.descriptiveTitle h1').text
  station_address =  station.search('.ms-rteTable-0 .ms-rteElement-P')[1].text.gsub(/([a-z])([A-Z])/, '\1, \2')
  station_telephone = station.search('.ms-rteTable-0 .ms-rteElement-P')[3].text.gsub(/\s+/,'')
  {
    station_name: station_name,
    station_address: station_address,
    station_telephone: station_telephone
  }
end

puts "Saving to data.sqlite\n"

stations.each do |station|
  ScraperWiki.save_sqlite([:station_name, :station_address], station)
end

#puts JSON.pretty_generate(stations)
