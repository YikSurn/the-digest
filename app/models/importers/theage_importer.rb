require_relative '../importer.rb'

require 'Date'
require 'rss'
require 'open-uri'
require 'cgi'

# Data importer for The Age news
class AgeImporter < ArticleImporter

  def initialize url, source
    super()
    @url = url
    @source = source
  end

  # Extract data from the RSS feed
  def scrape
    open(@url) do |rss|
      feed = RSS::Parser.parse(rss)

      feed.items.each do |item|

        # Remove the p tag and retrieve image url from the description if it exists
        p_tag = item.description[/<p>.*<\/p>/]
        if p_tag
          item.description.slice! p_tag
          img_url = p_tag.match(/src="(?<img>[^"]*)"/)[:img]
        else
          img_url = nil
        end

        # Sanitize HTML
        item.title = CGI.unescapeHTML(item.title)
        item.description = CGI.unescapeHTML(item.description)

        @articles.push({
          title: item.title,
          summary: item.description,
          image_url: img_url,
          source: @source,
          url: item.link,
          pub_date: item.pubDate.to_s,
          guid: item.guid.content,
        })
      end
    end
  end

end
