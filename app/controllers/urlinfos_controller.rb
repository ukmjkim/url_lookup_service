class UrlinfosController < ApplicationController
  before_action :set_urlinfo, only: [:show, :update, :destroy]
  before_action :fetch_urlinfo_from_storage, only: [:find_by_url]
  before_action :fetch_urlinfo_from_database, only: [:delete_by_url]

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
    json_response(@result)
  end

  def create_by_url
    param_url = generate_url_from_params 
    Urlinfo.make_empty_response_object(param_url)
    @urlinfo = Urlinfo.where(domain_name: params[:domain_name],
                             query_string: params[:query_string]).first
    if @urlinfo.nil?
      @urlinfo = Urlinfo.create!(:url => param_url,
                                 :malware => true,
                                 :created_by => params[:requested_by],
                                 :domain_name => params[:domain_name],
                                 :query_string => params[:query_string])
    else
      @urlinfo.update(:url => param_url,
                      :malware => true,
                      :created_by => params[:requested_by],
                      :domain_name => params[:domain_name],
                      :query_string => params[:query_string])
    end
    @result[:data_from] = "database"
    @result[:malware] = true 
    json_response(@result, :created)
  end

  def delete_by_url
    @urlinfo.destroy_all
    head :no_content
  end

  private

  def set_urlinfo
    @urlinfo = Urlinfo.find(params[:id])
  end

  def fetch_urlinfo_from_storage
    # 1. generating full uri from domain_name and query_string
    #     cache stores full uri as key and malware flag as value
    param_url = generate_url_from_params
    # 2. making empty response object with full uri
    make_empty_response_object(param_url)
    # 3. looking up the requested uri in cache first
    cached_value = fetch_urlinfo_from_cache(param_url)
    if cached_value.nil?
      # 4. if not found in cache then looking it up in database
      fetch_urlinfo_from_database(params)
    end
  end

  def fetch_urlinfo_from_database(params)
    @urlinfo = Urlinfo.where(domain_name: params[:domain_name], query_string: params[:query_string]).first
    malware_flag = @urlinfo.nil? ? false : true
    @result[:data_from] = "database"
    @result[:malware] = malware_flag
    param_url = generate_url_from_params
    Urlinfo.set_url_in_cache(param_url, malware_flag)
  end

  def fetch_urlinfo_from_cache(param_url)
    cached_value = Urlinfo.get_url_in_cache(param_url)
    if cached_value.nil?
      return nil
    else
      # updating cached url again to prevent the data from being expired (LRU)
      Urlinfo.set_url_in_cache(param_url, cached_value)
      @result[:malware] = cached_value == "true" ? true : false
      @result[:data_from] = "cache"
    end
  end

  def make_empty_response_object(param_url)
    @result = {
      :url => param_url,
      :malware => nil,
      :data_from => nil 
    }
  end

  def generate_url_from_params
    if params[:query_string].nil?
      "#{params[:domain_name]}"
    else
      "#{params[:domain_name]}/?#{params[:query_string]}"
    end
  end
end
