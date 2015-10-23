require_relative '../tagger.rb'

class SourceTagger < ArticleTagger

  def initialize
    super
  end

  def get_tags article
    tags = [ article[:source].name ]
  end

end
