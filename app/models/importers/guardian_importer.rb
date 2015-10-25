require_relative '../importer.rb'

require 'Date'
require 'json'
require 'net/http'
require 'cgi'

# Data importer for The Guardian
class GuardianImporter < ArticleImporter
  def initialize(url, source)
    super()
    @url = url
    @source = source
  end

  # Extract the data from the rss
  def scrape
    uri = URI.parse(@url)
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true if uri.scheme == 'https'

    # Make a GET request to the given url
    response = http.send_request('GET', uri.request_uri)

    # Parse the response body
    response = JSON.parse(response.body)
    data = response['response']
    article_list = data['results']

    article_list.each do |item|
      # Sanitize HTML
      item['title'] = CGI.unescapeHTML(item['webTitle'])

      @articles.push(
        title: item['title'],
        source: @source,
        url: item['webUrl'],
        pub_date: item['webPublicationDate']
      )
    end
  end
end
