require_relative 'taggers/alchemy_tagger.rb'
require_relative 'taggers/engtag_tagger.rb'
require_relative 'taggers/indico_tagger.rb'
require_relative 'taggers/opencalais_tagger.rb'
require_relative 'taggers/source_tagger.rb'

TAGGERS = [
  AlchemyTagger.new,
  EngTagTagger.new,
  IndicoTagger.new,
  OpenCalaisTagger.new,
  SourceTagger.new
]

# Module to tag the articles
module ArticleTagService
  # Add tags using the taggers in TAGGERS to each of the articles
  def self.tag(articles)
    articles.each do |article|
      tags = []
      TAGGERS.each do |tagger|
        tags += tagger.get_tags(article)
      end

      tags.map!(&:downcase).uniq!

      article[:tag_list] = tags
    end
  end
end
