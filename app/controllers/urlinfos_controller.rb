class UrlinfosController < ApplicationController
  before_action :set_urlinfo, only: [:show, :update, :destroy]
  before_action :set_urlinfo_from_cache, only: [:find_by_url]
  before_action :set_urlinfo_from_db, only: [:delete_by_url]

  def index
    @urlinfos = Urlinfo.all
    json_response(@urlinfos)
  end

  def create
    @urlinfo = Urlinfo.create!(params.permit(:url, :malware, :created_by))
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
    json_response(@urlinfo)
  end

  def create_by_url
    param_url = generate_url_from_params 
    @urlinfo = Urlinfo.where(domain_name: params[:domain_name], query_string: params[:query_string]).first
    if @urlinfo.nil?
      @urlinfo = Urlinfo.create!(:url => param_url, :malware => true, :created_by => params[:requested_by], :domain_name => params[:domain_name], :query_string => params[:query_string])
    else
      @urlinfo.update(:url => param_url, :malware => true, :created_by => params[:requested_by], :domain_name => params[:domain_name], :query_string => params[:query_string])
    end
    json_response(@urlinfo, :created)
  end

  def delete_by_url
    @urlinfo.destroy_all
    head :no_content
  end

  private

  def set_urlinfo
    @urlinfo = Urlinfo.find(params[:id])
  end

  def set_urlinfo_from_cache
    param_url = generate_url_from_params
    @urlinfo = Urlinfo.get_url_in_cache(param_url)
    if @urlinfo.nil?
      set_urlinfo_from_db
    end
  end

  def set_urlinfo_from_db
    @urlinfo = Urlinfo.where(domain_name: params[:domain_name], query_string: params[:query_string])
  end

  def generate_url_from_params
    if params[:query_string].nil?
      "#{params[:domain_name]}"
    else
      "#{params[:domain_name]}/?#{params[:query_string]}"
    end
  end
end
