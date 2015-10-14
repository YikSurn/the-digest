require_relative '../models/importers/smh_importer.rb'
require_relative '../models/importers/heraldsun_importer.rb'
require_relative '../models/importers/abc_importer.rb'
require_relative '../models/importers/theage_importer.rb'
require_relative '../models/importers/sbs_importer.rb'
require_relative '../models/importers/nytimes_importer.rb'
require_relative '../models/importers/guardian_importer.rb'

module ArticleScrapeService

  # Update the articles with all the feeds available in Feed database
  def self.scrape
    articles = []
    feeds = Feed.all
    feeds.each do |feed|
      case feed.name
      when 'Sydney Morning Herald'
        importer = SMHImporter.new(feed.url, feed)
      when 'Herald Sun'
        importer = HeraldSunImporter.new(feed.url, feed)
      when 'ABC'
        importer = ABCImporter.new(feed.url, feed)
      when 'The Age'
        importer = AgeImporter.new(feed.url, feed)
      when 'SBS'
        importer = SBSImporter.new(feed.url, feed)
      when 'New York Times'
        importer = NYTimesImporter.new(feed.url, feed)
      when 'The Guardian'
        importer = GuardianImporter.new(feed.url, feed)
      end
      importer.scrape
      articles += importer.articles
    end

    articles.uniq!

    articles.each do |article|
      # Save article only if it doesn't already exist in database
      if article.guid
        article.save if Article.where(guid: article.guid).empty?
      elsif Article.where(url: article.url).empty?
        article.save
      end
    end
  end

end
