require_relative '../tagger.rb'

require 'indico'

class IndicoTagger < ArticleTagger

  def initialize
    super
    Indico.api_key = ENV['INDICO_APIKEY']
  end

  def get_tags article
    text = article[:title] + ' ' + article[:summary].to_s
    tags = []

    keywords = Indico.keywords(text, {relative: true})
    keywords.each { |k, v| tags << k if v.to_f >= @MIN_SCORE }

    text_tags = Indico.text_tags(text, {top_n: 3})
    text_tags.each do |k, _v|
      s = k.dup
      s.gsub!('_', ' ')
      tags << s
    end

    named_entities = Indico.named_entities(text, {threshold: @MIN_SCORE})
    named_entities.each { |k, _v| tags << k }

    return tags
  end

end
