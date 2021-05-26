# frozen_string_literal: true

# Working with articles
class CommentsController < ApplicationController
  # POST /comments
  def create
    article = Article.find(params[:article_id])
    comment = article.comments.new(comment_params)
    if comment.save
      render json: comment
    else
      render json: { errors: comment.errors.full_messages }, status: 400
    end
  end

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
