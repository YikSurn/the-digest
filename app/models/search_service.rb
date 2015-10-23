TAG_LIST_WEIGHT = 4
TITLE_WEIGHT = 3
SUMMARY_WEIGHT = 2
SOURCE_NAME_WEIGHT = 1

module SearchService

  def self.search keywords
    keywords.each { |k| k.downcase! }

    all_articles = Article.all.order(pub_date: :desc)

    # weights = Hash.new { |hash, key| hash[key] = Array.new }
    weights = Hash.new

    # Get articles that match to the keywords
    all_articles.each do |article|
      if self.article_match?(article, keywords)
        weights[article] = self.calc_weight(article, keywords)
      end
    end

    weights.sort_by { |k, v| [v, k.pub_date] }.reverse.to_h

    return weights.keys
  end

  def self.article_match? article, keywords
    match_arg = [article.tag_list, article.title.downcase, article.source.name.downcase]
    match_arg << article.summary.downcase unless article.summary.nil?

    keywords.each do |keyword|
      return false if not match_arg.any? { |arg| arg.include?(keyword) }
    end

    # article matches the keywords
    return true
  end

  def self.calc_weight article, keywords
    weight = 0

    appearance_w = {
      article.tag_list => TAG_LIST_WEIGHT,
      article.title.downcase => TITLE_WEIGHT,
      article.summary.downcase => SUMMARY_WEIGHT,
      article.source.name.downcase => SOURCE_NAME_WEIGHT
    }

    keywords.each do |keyword|
      appearance_w.each do |arg, w|
        weight += w if arg.include?(keyword)
      end
    end

    return weight
  end

end
