# The controller to provide urlinfo service
class UrlinfosController < ApplicationController
  before_action :set_urlinfo, only: %i[show update destroy]

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
    lookup_result = Urlinfo.new.find_urlinfo_in_storage(params)
    json_response(lookup_result)
  end

  def create_by_url
    lookup_result = Urlinfo.new.create_urlinfo_in_database(params)
    json_response(lookup_result, :created)
  end

  def delete_by_url
    lookup_result = Urlinfo.new.destroy_urlinfo_from_database(params)
    json_response(lookup_result, :ok)
  end

  private

  def set_urlinfo
    @urlinfo = Urlinfo.find(params[:id])
  end
end
