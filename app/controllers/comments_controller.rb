# frozen_string_literal: true

# Working with articles
class CommentsController < ApplicationController
  # # GET /comments
  # def index
  #   render json: Article.all
  # end

  # # GET /comments/:id
  # def show
  #   render json: Article.find(params[:id])
  # end

  # POST /comments
  def create
    article = Article.find(params[:article_id])
    article.comments.create(comment_params)
    render json: { message: 'Comment created successfully' }
  end

  # # PUT /comments/:id
  # def update
  #   article = Article.find(params[:id])
  #   if article.update(article_params)
  #     render json: article
  #   else
  #     render json: { errors: article.errors.full_messages }, status: 400
  #   end
  # end

  # DELETE /comments/:id
  def destroy
    article = Article.find(params[:article_id])
    comment = article.comments.find(params[:id])
    comment.destroy
    render json: { message: 'Comment destroyed successfully' }
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body, :status)
  end
end
