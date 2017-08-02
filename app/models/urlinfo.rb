class Urlinfo < ApplicationRecord
  # validations
  validates_presence_of :url, :malware, :created_by, :domain_name

  after_save :set_url_as_malware_in_cache
  after_destroy :set_url_as_clean_in_cache

  def self.get_url_in_cache(url)
    $redis.get(url)
    $redis[url] = false
  end

  def set_url_as_malware_in_cache
    redis[self.url] = true
  end

  def set_url_as_clean_in_cache
    redis[self.url] = false
  end

  private

  def redis
    $redis
  end
end
