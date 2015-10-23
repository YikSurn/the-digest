class AdminController < ApplicationController

  include ArticleScrapeService
  include ArticleTagService
  include NewsDigestService

  def scrape
    articles = ArticleScrapeService.scrape

    # Tag and save articles only if it doesn't already exist in database
    articles.each do |article|
      if article[:guid]
        articles.delete(article) if Article.where(title: article[:title], guid: article[:guid]).empty?
      elsif Article.where(url: article[:url]).empty?
        articles.delete(article)
      end
    end

    articles = ArticleTagService.tag(articles)

    articles.each { |a| Article.create(a) }

    redirect_to articles_path, notice: 'Articles successfully updated.'
  end

  def email
    news_digest
  end

end
