require_relative '../importer.rb'

require 'Date'
require 'json'
require 'net/http'
require 'cgi'

# Data importer for New York Times
class NYTimesImporter < ArticleImporter

  def initialize url, source
    super()
    @url = url
    @source = source
  end

  # Source name of class
  def self.source_name
    'New York Times'
  end

  # Extract the data from the rss
  def scrape
    uri = URI.parse(@url)
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true if uri.scheme == 'https'

    # Make a GET request to the given url
    response = http.send_request('GET', uri.request_uri)

    # Parse the response body
    data = JSON.parse(response.body)

    article_list = data['results']

    article_list.each do |item|

      # Add article tags
      tag_list = []
      tag_list.push(item['section'])
      tag_list.push(item['subsection']) unless item['subsection'].empty?
      tag_list += item['des_facet'] unless item['des_facet'].empty?
      tag_list += item['org_facet'] unless item['org_facet'].empty?
      tag_list += item['geo_facet'] unless item['geo_facet'].empty?
      tag_list.push(self.class.source_name)
      tag_list.uniq!

      item['byline'].slice!('By ')

      # Get image
      image_url = nil
      unless item['multimedia'].empty?
        item['multimedia'].each do |image|
          if image['format'] == 'Normal'
            image_url = image['url']
            break
          end
        end
      end

      # Sanitize HTML
      item['title'] = CGI.unescapeHTML(item['title'])
      item['abstract'] = CGI.unescapeHTML(item['abstract'])
      item['byline'] = CGI.unescapeHTML(item['byline'])

      @articles.push(Article.new(
        author: item['byline'],
        title: item['title'],
        summary: item['abstract'],
        image_url: image_url,
        source: @source,
        url: item['url'],
        pubDate: item['published_date'],
        tag_list: tag_list
      ))
    end
  end

end
