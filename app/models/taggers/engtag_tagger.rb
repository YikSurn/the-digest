require_relative '../tagger.rb'

require 'engtagger'

# Tagger using engtagger gem
class EngTagTagger < ArticleTagger
  def initialize
    super
    @tgr = EngTagger.new
  end

  def get_tags(article)
    text = article[:title] + ' ' + article[:summary].to_s
    tags = []

    tagged = @tgr.add_tags(text)

    nouns = @tgr.get_nouns(tagged)
    nouns.each { |k, _v| tags << k }

    tags
  end
end
