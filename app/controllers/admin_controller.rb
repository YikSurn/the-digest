# Controller for admin methods
class AdminController < ApplicationController
  include ArticleScrapeService
  include ArticleTagService
  include NewsDigestService

  def scrape
    articles = ArticleScrapeService.scrape
    articles = new_articles(articles)
    articles = ArticleTagService.tag(articles)
    articles.each { |a| Article.create(a) }
    redirect_to articles_path, notice: 'Articles successfully updated.'
  end

  def email
    NewsDigestService.news_digest
    redirect_to root_path, notice: 'News digests successfully sent to all'\
      ' subscribed users.'
  end

  private

  # Returns new articles
  def new_articles(articles)
    # Tag and save articles only if it doesn't already exist in database
    filtered_articles = []
    articles.each do |article|
      if article[:guid]
        filtered_articles << article if
          Article.where(title: article[:title], guid: article[:guid]).empty?
      elsif Article.where(url: article[:url]).empty?
        filtered_articles << article
      end
    end

    filtered_articles
  end
end
