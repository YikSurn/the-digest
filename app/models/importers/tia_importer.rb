require_relative '../importer.rb'

require 'Date'
require 'rss'
require 'open-uri'
require 'cgi'

# Data importer for Re/code news
class TiAImporter < ArticleImporter

  def initialize url, source
    super()
    @url = url
    @source = source
  end

  # Source name of class
  def self.source_name
    'Tech in Asia'
  end

  # Extract data from the RSS feed
  def scrape
    open(@url) do |rss|
      feed = RSS::Parser.parse(rss, do_validate=false)

      feed.items.each do |item|
        tag_list = []
        item.categories.each do |category|
          tag_list.push(category.content)
        end
        tag_list.push(self.class.source_name)
        tag_list.uniq!

        # Sanitize HTML
        item.title = CGI.unescapeHTML(item.title)
        item.description = CGI.unescapeHTML(item.description)
        item.dc_creator = CGI.unescapeHTML(item.dc_creator)

        @articles.push(Article.new(
          author: item.dc_creator,
          title: item.title,
          summary: item.description,
          image_url: item.enclosure.url,
          source: @source,
          url: item.link,
          pubDate: item.pubDate.to_s,
          guid: item.guid.content,
          tag_list: tag_list
        ))
      end
    end
  end

end
