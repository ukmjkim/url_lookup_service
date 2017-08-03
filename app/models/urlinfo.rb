# Urlinfo Model
class Urlinfo < ApplicationRecord
  # validations
  validates_presence_of :url, :malware, :created_by, :domain_name

  def get_url_in_cache(url)
    cache = get_cache_connection_by_url(url)
    cache.get(url)
  end

  def set_urlinfo_in_cache(url, malware)
    cache = get_cache_connection_by_url(url)
    cache[url] = malware
  end

  def del_urlinfo_from_cache(url)
    cache = get_cache_connection_by_url(url)
    cache.del(url)
  end

  def find_urlinfo_in_storage(params)
    param_url = generate_url_from_params(params)
    cached_value = get_url_in_cache(param_url)
    data_source = 'cache'
    malware = false
    if cached_value.nil?
      urlinfo = find_urlinfo(params)
      unless urlinfo.nil?
        data_source = 'database'
        malware = true
      end
    else
      malware = cached_value == 'true' ? true : false
    end
    set_urlinfo_in_cache(param_url, malware)

    { url: param_url, data_source: data_source, malware: malware }
  end

  def create_urlinfo_in_database(params)
    param_url = generate_url_from_params(params)
    urlinfo = find_urlinfo(params)
    if urlinfo.nil?
      create_urlinfo(param_url, params)
    else
      update_urlinfo(urlinfo, param_url, params)
    end
    set_urlinfo_in_cache(param_url, true)

    { url: param_url, data_source: 'database', malware: true }
  end

  def destroy_urlinfo_from_database(params)
    param_url = generate_url_from_params(params)
    Urlinfo.where(
      domain_name: params[:domain_name],
      query_string: params[:query_string]
    ).destroy_all
    del_urlinfo_from_cache(param_url)

    { url: param_url, data_source: 'none', malware: false }
  end

  private

  def find_urlinfo(params)
    Urlinfo.where(
      domain_name:  params[:domain_name],
      query_string: params[:query_string]
    ).first
  end

  def create_urlinfo(param_url, params)
    Urlinfo.create!(
      url:          param_url,
      malware:      true,
      created_by:   params[:requested_by],
      domain_name:  params[:domain_name],
      query_string: params[:query_string]
    )
  end

  def update_urlinfo(urlinfo, param_url, params)
    urlinfo.update(
      url: param_url,
      malware: true,
      created_by: params[:requested_by],
      domain_name: params[:domain_name],
      query_string: params[:query_string]
    )
  end

  def set_url_in_cache(url, malware_flag)
    cache = get_cache_connection_by_url(url)
    cache[url] = malware_flag
  end

  def generate_url_from_params(params)
    if params[:query_string].nil?
      params[:domain_name]
    else
      "#{params[:domain_name]}/?#{params[:query_string]}"
    end
  end

  def get_cache_connection_by_url(url)
    hashcode = (url.length % UrlLookupCache.redis.length)
    UrlLookupCache.redis[hashcode][:object]
  end
end
