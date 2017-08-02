# Urlinfo Model
class Urlinfo < ApplicationRecord
  # validations
  validates_presence_of :url, :malware, :created_by, :domain_name

  after_save :set_url_as_malware_in_cache
  after_destroy :set_url_as_clean_in_cache

  def set_url_as_malware_in_cache
    cache = Urlinfo.get_cache_connection_by_url(url)
    cache[url] = true
  end

  def set_url_as_clean_in_cache
    cache = Urlinfo.get_cache_connection_by_url(url)
    cache[url] = false
  end

  def self.get_url_in_cache(url)
    cache = Urlinfo.get_cache_connection_by_url(url)
    cache.get(url)
  end

  def self.set_url_in_cache(url, malware_flag)
    cache = Urlinfo.get_cache_connection_by_url(url)
    cache[url] = malware_flag
  end

  private

  def get_cache_connection_by_url(url)
    hashcode = (url.length % UrlLookupCache.redis.length)
    UrlLookupCache.redis[hashcode][:object]
  end
end
