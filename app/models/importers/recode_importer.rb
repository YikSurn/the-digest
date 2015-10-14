require_relative '../importer.rb'

require 'Date'
require 'rss'
require 'open-uri'
require 'cgi'

# Data importer for Re/code news
class RecodeImporter < ArticleImporter

  def initialize url, source
    super()
    @url = url
    @source = source
  end

  # Source name of class
  def self.source_name
    'Re/code'
  end

  # Extract data from the RSS feed
  def scrape
    open(@url) do |rss|
      feed = RSS::Parser.parse(rss)

      feed.items.each do |item|
        # Remove the img tag from the description
        img_tag = item.description[/(<[^>]*\/>)/]
        item.description.slice! img_tag

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
