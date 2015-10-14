class AdminController < ApplicationController
  include ArticleScrapeService

  def scrape
    ArticleScrapeService.scrape
    # @articles = Article.order(pubDate: :desc)
    # redirect_to articles_path, notice: 'Articles successfully updated.'
  end

  def email
  end

end
