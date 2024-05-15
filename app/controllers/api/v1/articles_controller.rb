class Api::V1::ArticlesController < ApplicationController
  def index
    status = params[:status]&.to_sym || :published
    articles = Article.where(status: status)
    render json: articles
  end
end