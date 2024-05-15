class InvalidRequestError < StandardError; end
class InvalidStatusError < StandardError; end

class Api::V1::ArticlesController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    status = params[:status]&.to_sym || :published
    articles = Article.where(status: status)
    render json: articles
  end

  def create
    raise InvalidRequestError if create_params[:status].nil?
    raise InvalidStatusError unless Article.statuses.keys.include?(create_params[:status])
    
    category = Category.find(create_params[:category_id])
    article = Article.create!(create_params.merge(category: category))
    render json: article
  end

  def update
    raise InvalidStatusError unless Article.statuses.keys.include?(create_params[:status])

    article = Article.find(params[:id])
    category = params[:category_id] ? Category.find(params[:category_id]) : article.category

    article.update!(update_params.merge(category: category))
    render json: { success: true }
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy!
    render json: { success: true }
  end

  private
  def create_params
    params.require(:article).permit(:title, :body, :status, :category_id)
  end

  def update_params
    params.require(:article).permit(:title, :body, :status, :category_id)
  end
end