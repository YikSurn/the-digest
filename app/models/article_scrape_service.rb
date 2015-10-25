require_relative 'importers/smh_importer.rb'
require_relative 'importers/heraldsun_importer.rb'
require_relative 'importers/abc_importer.rb'
require_relative 'importers/theage_importer.rb'
require_relative 'importers/sbs_importer.rb'
require_relative 'importers/nytimes_importer.rb'
require_relative 'importers/guardian_importer.rb'

# Module for scraping articles from sources
module ArticleScrapeService
  # Update the articles with all the sources available in Source database
  def self.scrape
    importers = []
    sources = Source.all
    sources.each do |source|
      case source.name
      when 'Sydney Morning Herald'
        importers << SMHImporter.new(source.url, source)
      when 'Herald Sun'
        importers << HeraldSunImporter.new(source.url, source)
      when 'ABC'
        importers << ABCImporter.new(source.url, source)
      when 'The Age'
        importers << AgeImporter.new(source.url, source)
      when 'SBS'
        importers << SBSImporter.new(source.url, source)
      when 'New York Times'
        importers << NYTimesImporter.new(source.url, source)
      when 'The Guardian'
        importers << GuardianImporter.new(source.url, source)
      end
    end

    articles = []
    importers.each do |importer|
      importer.scrape
      articles += importer.articles
    end

    articles.uniq! { |h| h[:title] }

    articles
  end
end
