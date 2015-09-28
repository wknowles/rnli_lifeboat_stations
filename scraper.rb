#!/usr/bin/env ruby

require 'mechanize'
#require 'json'
require 'scraperwiki'

ScraperWiki.config = { db: 'data.sqlite', default_table_name: 'data' }

mechanize = Mechanize.new
puts "Fetching Main Page ...\n"
page = mechanize.get('http://rnli.org/aboutus/lifeboatsandstations/stations/Pages/Stations-a-z.aspx')

puts "Finding Station Links\n"
station_links = page.links_with(href: %r{^\/findmynearest\/station\/Pages\/.*})

puts "Selecting First Twenty Stations\n"
station_links = station_links[0...20]

stations = station_links.map do |link|
  puts "Following Link to #{link} ...\n"
  station = link.click
  station_name = station.search('.descriptiveTitle h1')[0].text
  station_address =  station.search('.ms-rteTable-0 .ms-rteElement-P')[1].text
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
