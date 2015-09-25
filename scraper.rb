require 'scraperwiki'
require 'mechanize'

ScraperWiki.config = { db: 'data.sqlite', default_table_name: 'data' }

# Start mechanize
agent = Mechanize.new

# delay between requests
# agent.history_added = Proc.new { sleep 0.5 }

# get first page with list of rnli stations
  first_page = agent.get('http://rnli.org/aboutus/lifeboatsandstations/stations/Pages/Stations-a-z.aspx')

#list out links to station pages
station_links = first_page.search "//*[contains(@id, 'StationNavHyperLink')]"
station_links.each do |station_link|

# Write out to the sqlite database using scraperwiki library
# This is a little wierd - it saves everything in station_link not just href
ScraperWiki.save_sqlite(unique_keys=["name"], data={"name"=>station_link.content, "link"=>station_link['href']})

#print out result
#puts station_link.content
#puts station_link['href']

end
