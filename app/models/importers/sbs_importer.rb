require_relative '../importer.rb'

require 'Date'
require 'rss'
require 'open-uri'
require 'cgi'

# Data importer for SBS news
class SBSImporter < ArticleImporter

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
        # Tags for article
        tag_list = []
        title_token = item.title.gsub(/[^\w\s]/, '').split()
        title_token.each do |word|
          # If starts with a capital letter, the word is assumed to be a noun
          tag_list.push(word) unless (word[0].scan(/[A-Z]/).empty? or word.size == 1)
        end
        tag_list.push(self.class.source_name)
        tag_list.uniq!

        # Sanitize HTML
        item.title = CGI.unescapeHTML(item.title)
        item.description = CGI.unescapeHTML(item.description)

        @articles.push(Article.new(
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
