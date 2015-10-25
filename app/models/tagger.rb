# Abstract class for the taggers
class ArticleTagger
  def initialize
    @MIN_SCORE = 0.5
  end

  def min_score
    @MIN_SCORE
  end

  def get_tags(_article)
  end
end
