# frozen_string_literal: true

# Working with articles
class ArticlesController < ApplicationController
  skip_before_action :authenticate_request, except: %i[create update destroy]
  # GET /articles
  def index
    render json: Article.all.select(:id, :title).order('id ASC')
  end

  # GET /articles/:id
  def show
    render json: Article.find(params[:id]), include: :comments
  end

  # GET /articles/find/:q
  def find
    q = params[:q].downcase
    render json: Article.where('lower(title) like ?', "%#{q}%").or(Article.where('lower(body) like ?', "%#{q}%"))
      .select(:id, :title).order('id ASC')
  end

  # POST /articles
  def create
    data = article_params
    data = article_params.merge({ image: upload_image }) unless params[:image].nil?
    article = Article.new(data)
    if article.save
      render json: article
    else
      render json: { errors: article.errors.full_messages }, status: 400
    end
  end

  # PUT /articles/:id
  def update
    article = Article.find(params[:id])
    delete_image(article.image) unless article.image.nil?
    data = article_params
    data = article_params.merge({ image: upload_image }) unless params[:image].nil?
    if article.update(data)
      render json: article
    else
      render json: { errors: article.errors.full_messages }, status: 400
    end
  end

  # DELETE /articles/:id
  def destroy
    article = Article.find(params[:id])
    delete_image(article.image) unless article.image.nil?
    article.destroy
    render json: { message: 'Article destroyed successfully' }
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :status)
  end

  require 'aws-sdk-s3'
  require 'base64'
  def upload_image
    path = 'images/' + ('a'..'z').to_a.sample(8).join + '.jpg'
    file = StringIO.new(Base64.decode64(params[:image].split(',')[1]))
    client = aws_client
    client.put_object({
      bucket: 'rails-blog',
      key: path,
      body: file,
      acl: 'public-read'
    })
    path
  end

  def delete_image(path)
    client = aws_client
    client.delete_object({
      bucket: 'rails-blog',
      key: path
    })
  end

  def aws_client
    Aws::S3::Client.new(
      access_key_id: ENV['SPACES_KEY'],
      secret_access_key: ENV['SPACES_SECRET'],
      endpoint: 'https://fra1.digitaloceanspaces.com',
      region: 'us-east-1'
    )
  end
end
