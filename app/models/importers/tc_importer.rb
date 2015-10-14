require_relative '../importer.rb'

require 'Date'
require 'rss'
require 'open-uri'
require 'cgi'

# Data importer for TechCrunch news
class TCImporter < ArticleImporter

  def initialize url, source
    super()
    @url = url
    @source = source
  end

  # Source name of class
  def self.source_name
    'Tech Crunch'
  end

  # Extract data from the RSS feeds
  def scrape
    open(@url) do |rss|
      feed = RSS::Parser.parse(rss)

      feed.items.each do |item|
        datetime = DateTime.strptime(item.pubDate.to_s, "%a, %d %b %Y %T %z")
        date = Date.parse(datetime.to_s)

        # Retrieve image url from the description
        img_tag = item.description[/(<img[^>]*\/>)&nbsp;/]
        img_url = img_tag ? img_tag.match(/src="(?<img>[^"]*)"/)[:img] : nil

        if img_tag
          item.description.slice! img_tag
        end

        # Remove the image tag at the end of the description
        empty_img_feedburner = item.description[/(<img[^>]*\/>)/]
        item.description.slice! empty_img_feedburner

        # Remove the a tag for reading more on the article from the description
        read_more_tag = item.description[/<a .*<\/a>/]
        item.description.slice! read_more_tag

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
          image_url: img_url,
          source: @source,
          url: item.link,
          pubDate: item.pubDate,
          guid: item.guid.content,
          tag_list: tag_list
        ))
      end

    end

  end

end
