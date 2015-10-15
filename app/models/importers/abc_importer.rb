require_relative '../importer.rb'

require 'Date'
require 'rss'
require 'open-uri'
require 'cgi'

# Data importer for ABC news
class ABCImporter < ArticleImporter

  def initialize url, source
    super()
    @url = url
    @source = source
  end

  # Extract data from the RSS feed
  def scrape
    open(@url) do |rss|
      feed = RSS::Parser.parse(rss, do_validate=false)

      feed.items.each do |item|
        item.description = item.description.match(/<p>(?<description>.*)<\/p>/)[:description]

        # Sanitize HTML
        item.title = CGI.unescapeHTML(item.title)
        item.description = CGI.unescapeHTML(item.description)

        item.author = CGI.unescapeHTML(item.dc_creator) if item.dc_creator

        @articles.push(Article.new(
          title: item.title,
          author: item.author,
          summary: item.description,
          source: @source,
          url: item.link,
          pub_date: item.pubDate.to_s,
          guid: item.guid.content,
        ))
      end
    end
  end

end
