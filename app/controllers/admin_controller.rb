class AdminController < ApplicationController
  include ArticleScrapeService

  def scrape
    articles = ArticleScrapeService.scrape
    # @articles = Article.order(pubDate: :desc)

    articles.each do |article|
      # Save article only if it doesn't already exist in database
      if article.guid
        article.save if Article.where(title: article.title, guid: article.guid).empty?
      elsif Article.where(url: article.url).empty?
        article.save
      end
    end

    redirect_to articles_path, notice: 'Articles successfully updated.'
  end

  def email
  end

end
