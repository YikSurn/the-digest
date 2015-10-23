require_relative '../tagger.rb'

require 'open_calais'

class OpenCalaisTagger < ArticleTagger

  def initialize
    super
    @oc = OpenCalais::Client.new(api_key: ENV['OPENCALAIS_APIKEY'])
  end

  def get_tags article
    text = article[:title] + ' ' + article[:summary].to_s
    tags = []

    response = @oc.enrich(text)
    response.entities.each { |t| tags << t[:name] if t[:score].to_f >= @MIN_SCORE}
    response.tags.each { |t| tags << t[:name] if t[:score].to_f >= @MIN_SCORE}
    response.topics.each { |t| tags << t[:name] if t[:score].to_f >= @MIN_SCORE}

    return tags
  end

end
