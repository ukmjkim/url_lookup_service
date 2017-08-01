class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :update, :destroy]

  def index
    @urls = Url.all
    json_response(@urls)
  end

  def create
    @url = Url.create!(url_params)
    json_response(@url, :created)
  end

  def show
    json_response(@url)
  end

  def destroy
    @url.destroy
    head :no_content
  end

  private

  def url_params
    params.permit(:url, :created_by)
  end

  def set_url
    @url = Url.find(params[:id])
  end
end
