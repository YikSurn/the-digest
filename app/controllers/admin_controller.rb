class AdminController < ApplicationController

  include ArticleScrapeService
  include ArticleTagService
  include NewsDigestService

  def scrape
    articles = ArticleScrapeService.scrape

    # Tag and save articles only if it doesn't already exist in database
    new_articles = []
    articles.each do |article|
      if article[:guid]
        new_articles << article if Article.where(title: article[:title], guid: article[:guid]).empty?
      elsif Article.where(url: article[:url]).empty?
        new_articles << article
      end
    end

    new_articles = ArticleTagService.tag(new_articles)

    new_articles.each { |a| Article.create(a) }

    redirect_to articles_path, notice: 'Articles successfully updated.'
  end

  def email
    NewsDigestService.news_digest
  end

end
