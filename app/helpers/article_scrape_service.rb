require_relative '../models/importers/smh_importer.rb'
require_relative '../models/importers/heraldsun_importer.rb'
require_relative '../models/importers/abc_importer.rb'
require_relative '../models/importers/theage_importer.rb'
require_relative '../models/importers/sbs_importer.rb'
require_relative '../models/importers/nytimes_importer.rb'
require_relative '../models/importers/guardian_importer.rb'

module ArticleScrapeService

  # Update the articles with all the sources available in Source database
  def self.scrape
    articles = []
    sources = Source.all
    sources.each do |source|
      case source.name
      when 'Sydney Morning Herald'
        importer = SMHImporter.new(source.url, source)
      when 'Herald Sun'
        importer = HeraldSunImporter.new(source.url, source)
      when 'ABC'
        importer = ABCImporter.new(source.url, source)
      when 'The Age'
        importer = AgeImporter.new(source.url, source)
      when 'SBS'
        importer = SBSImporter.new(source.url, source)
      when 'New York Times'
        importer = NYTimesImporter.new(source.url, source)
      when 'The Guardian'
        importer = GuardianImporter.new(source.url, source)
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
