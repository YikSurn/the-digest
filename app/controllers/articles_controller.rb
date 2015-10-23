class ArticlesController < ApplicationController

  include SearchService

  before_action :set_article, only: [:show]
  before_action :authenticate_user

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.paginate(:page => params[:page]).order(pub_date: :desc)
  end

  # GET /articles/interests
  # GET /articles/interests.json
  def interests
    @articles = Article.tagged_with(current_user.interest_list, :any => true).paginate(:page => params[:page]).order(pub_date: :desc)
    render 'index'
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  def search
    keywords = params[:keywords].split()
    @articles = SearchService.search(keywords).paginate(page: params[:page])
    render 'index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

end
