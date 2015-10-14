
class ArticleImporter

  # A news scrape is initialised with the start and end date, it
  # then validates that the required methods are provided
  def initialize
    @articles = []
  end

  # Method to return news articles, ensuring that we only return
  # unique news articles
  def articles
    @articles.uniq
  end

end
