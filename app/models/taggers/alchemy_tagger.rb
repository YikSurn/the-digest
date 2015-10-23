require_relative '../tagger.rb'

require 'alchemy_api'

class AlchemyTagger < ArticleTagger

  def initialize
    super
    AlchemyAPI.key = ENV['ALCHEMY_APIKEY']
    @entity_extraction = AlchemyAPI::EntityExtraction.new
    @concept_tagging = AlchemyAPI::ConceptTagging.new
  end

  def get_tags article
    text = article[:title] + ' ' + article[:summary].to_s
    tags = []

    entities = @entity_extraction.search(text: text)
    concepts = @concept_tagging.search(text: text)

    entities.each { |e| tags << e['text'] if e['relevance'].to_f >= @MIN_SCORE }
    concepts.each { |c| tags << c['text'] if c['relevance'].to_f >= @MIN_SCORE }

    return tags
  end

end
