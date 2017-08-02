class Urlinfo < ApplicationRecord
  # validations
  validates_presence_of :url, :malware, :created_by, :domain_name

  after_save :set_url_as_malware_in_cache
  after_destroy :set_url_as_clean_in_cache

  def set_url_as_malware_in_cache
    cache = Urlinfo.getCacheConnectionByUrl(self.url)
    cache[self.url] = true
  end

  def set_url_as_clean_in_cache
    cache = Urlinfo.getCacheConnectionByUrl(self.url)
    cache[self.url] = false
  end

  def self.get_url_in_cache(url)
    cache = getCacheConnectionByUrl(url)
    cache.get(url)
  end

  def self.set_url_in_cache(url, malware_flag)
    cache = getCacheConnectionByUrl(url)
    cache[url] = malware_flag
  end

  private

  def self.getCacheConnectionByUrl(url)
    hashcode = (url.length % UrlLookupCache.redis.length)
puts "url = #{url.length}, number of redis= #{UrlLookupCache.redis.length} hashcode = #{hashcode}"
    UrlLookupCache.redis[hashcode][:object]
  end
end
