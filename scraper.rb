#!/usr/bin/env ruby

require 'scraperwiki'
require 'mechanize'

ScraperWiki.config = { db: 'data.sqlite', default_table_name: 'data' }

# Start mechanize
mechanize = Mechanize.new

# get first page with list of rnli stations and search for links to next stations
station_links = mechanize.get('http://rnli.org/aboutus/lifeboatsandstations/stations/Pages/Stations-a-z.aspx').search("//*[contains(@id, 'StationNavHyperLink')]")
#station_links.each { |station_link| puts station_link['href'] }

#list out links to station pages
#station_links = station_links.search "//*[contains(@id, 'StationNavHyperLink')]"
station_links.each do |station_link|

  #mechanize.click(station_link)
  #station_page = station_link
  #station_address = station_page.search "//*[@id='ctl00_PlaceHolderMain_MegaRollup_RepeaterContainer_ctl01_PageRendererLoader_ctl00_EditModePanel8']/div/table/tbody/tr[1]/td[2]/p"[0].text
  #station_vessel = station_info.search(//*[@id='ctl00_PlaceHolderMain_MegaRollup_RepeaterContainer_ctl05_PageRendererLoader_ctl00_EditModePanel8']/table/tbody/tr[1]/td[2]/p[1]/em)[0].text
  #puts station_address
  #puts station_vessel

#parse urls to individual stations
base_rnli_url = "http://rnli.org"
station_url = "#{base_rnli_url}#{station_link['href']}"

#print to screen
#puts station_url

# Write out to the sqlite database using scraperwiki library
ScraperWiki.save_sqlite(unique_keys=["name"], data={"name"=>station_link.content, "link"=>station_url})

end
