require_relative '../importer.rb'

require 'Date'
require 'rss'
require 'open-uri'
require 'cgi'

# Data importer for Herald Sun news
class HeraldSunImporter < ArticleImporter
  def initialize(url, source)
    super()
    @url = url
    @source = source
  end

  # Extract data from the RSS feed
  def scrape
    open(@url) do |rss|
      feed = RSS::Parser.parse(rss)

      feed.items.each do |item|
        element_tag = item.description[%r{<[a-z]*>.*</[a-z]*>}]

        item.description.slice! element_tag if element_tag

        # Sanitize HTML
        item.title = CGI.unescapeHTML(item.title)
        item.description = CGI.unescapeHTML(item.description)

        @articles.push(
          title: item.title,
          summary: item.description,
          image_url: item.enclosure.url,
          source: @source,
          url: item.link,
          pub_date: item.pubDate.to_s,
          guid: item.guid.content
        )
      end
    end
  end
end
