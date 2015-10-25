require_relative '../tagger.rb'

# A source tagger
class SourceTagger < ArticleTagger
  def initialize
    super
  end

  def get_tags(article)
    [article[:source].name]
  end
end
