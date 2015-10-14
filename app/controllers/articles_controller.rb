class ArticlesController < ApplicationController

  include ArticlesHelper

  before_action :set_article, only: [:show]
  before_action :authenticate_user

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.order(pubDate: :desc)
  end

  # GET /articles/interests
  # GET /articles/interests.json
  def interests
    @articles = Article.tagged_with(current_user.interest_list, :any => true).order(pubDate: :desc)
    render 'index'
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  def add_articles
    update_articles
    @articles = Article.order(pubDate: :desc)
    redirect_to articles_path, notice: 'Articles successfully updated.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

end
