require_relative '../models/importers/tc_importer.rb'
require_relative '../models/importers/tia_importer.rb'
require_relative '../models/importers/recode_importer.rb'
require_relative '../models/importers/smh_importer.rb'
require_relative '../models/importers/heraldsun_importer.rb'
require_relative '../models/importers/nytimes_importer.rb'

module ArticlesHelper

  # Update the articles with all the sources available in Source database
  def update_articles
    articles = []
    sources = Source.all
    sources.each do |source|
      case source.name
      when 'Tech Crunch'
        importer = TCImporter.new(source.url, source)
      when 'Tech in Asia'
        importer = TiAImporter.new(source.url, source)
      when 'Re/code'
        importer = RecodeImporter.new(source.url, source)
      when 'Sydney Morning Herald'
        importer = SMHImporter.new(source.url, source)
      when 'Herald Sun'
        importer = HeraldSunImporter.new(source.url, source)
      when 'New York Times'
        importer = NYTimesImporter.new(source.url, source)
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
