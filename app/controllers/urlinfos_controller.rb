class UrlinfosController < ApplicationController
  before_action :set_urlinfo, only: [:show, :update, :destroy]
  before_action :set_urlinfo_by_url, only: [:find_by_url]

  def index
    @urlinfos = Urlinfo.all
    json_response(@urlinfos)
  end

  def create
    @urlinfo = Urlinfo.create!(urlinfo_params)
    json_response(@urlinfo, :created)
  end

  def show
    json_response(@urlinfo)
  end

  def destroy
    @urlinfo.destroy
    head :no_content
  end

  def find_by_url
     puts params[:num]
     puts params[:domain_name]
     puts params[:query_string]
  end

  private

  def urlinfo_params
    params.permit(:url, :malware, :created_by)
  end

  def set_urlinfo
    @urlinfo = Urlinfo.find(params[:id])
  end

  def set_urlinfo_by_url
    puts params[:domain_name]
    puts params[:query_string]
  end
end
