#!/usr/bin/env ruby

require 'scraperwiki'
require 'mechanize'

ScraperWiki.config = { db: 'data.sqlite', default_table_name: 'data' }

# Start mechanize
agent = Mechanize.new

# get first page with list of rnli stations
first_page = agent.get('http://rnli.org/aboutus/lifeboatsandstations/stations/Pages/Stations-a-z.aspx')

#list out links to station pages
station_links = first_page.search "//*[contains(@id, 'StationNavHyperLink')]"
station_links.each do |station_link|


#parse urls to individual stations
base_rnli_url = "http://rnli.org"
station_url = "#{base_rnli_url}#{station_link['href']}"



# Write out to the sqlite database using scraperwiki library
ScraperWiki.save_sqlite(unique_keys=["name"], data={"name"=>station_link.content, "link"=>station_url})

#print out result
#puts station_link.content
#puts station_link['href']

end
