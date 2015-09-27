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

#puts "#{station_links}"

puts "Selecting First Eight Stations\n"
station_links = station_links[0...8]

stations = station_links.map do |link|
  puts "Following Link to #{link} ...\n"
  station = link.click
  puts "Searching for Station Information\n"
  station_meta = station.search('#ctl00_PlaceHolderMain_PrimaryContainerPanel')
  puts "Searching for Station Name\n"
  station_name = station_meta.search('#ctl00_PlaceHolderMain_PageRendererLoaderOnLoad_ctl00_EditModePanelDisp > h1')[0].text
  puts "#{station_name}\n"
  puts "Searching for Station Address\n"
  station_address =  station_meta.search('.ms-rteTable-0 .ms-rteElement-P')[1].text
  puts "#{station_address}\n"
  puts "Searching for Station Telephone\n"
  station_telephone = station_meta.search('.ms-rteTable-0 .ms-rteElement-P')[3].text
  puts "#{station_telephone}\n"
  {
    station_name: station_name,
    station_address: station_address,
    station_telephone: station_telephone
  }
end

puts "Saving data to sqlite\n"

stations.each do |station|
  ScraperWiki.save_sqlite([:station_name, :station_address, :station_telephone], station)
end

#puts JSON.pretty_generate(stations)
