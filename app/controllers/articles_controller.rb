# frozen_string_literal: true

# Working with articles
class ArticlesController < ApplicationController
  # GET /articles
  def index
    render json: Article.all
  end

  # GET /articles/:id
  def show
    render json: Article.find(params[:id])
  end

  # POST /articles
  def create
    article = Article.new(article_params)
    if article.save
      render json: article
    else
      render json: { errors: article.errors.full_messages }, status: 400
    end
  end

  # PUT /articles/:id
  def update
    article = Article.find(params[:id])
    if article.update(article_params)
      render json: article
    else
      render json: { errors: article.errors.full_messages }, status: 400
    end
  end

  # DELETE /articles/:id
  def destroy
    article = Article.find(params[:id])
    article.destroy
    render json: {message: 'Article destroyed successfully'}
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :status)
  end
end