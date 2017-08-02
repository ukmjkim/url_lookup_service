module UrlLookupCache
  class << self
    def redis
      REDIS_INSTANCE_LIST.each do |_key, redis_instance|
        redis_instance[:object] ||= Redis.new(
          :url => (redis_instance[:url] || 'redis://127.0.0.1:6379')
        )
      end
      REDIS_INSTANCE_LIST
    end
  end
end
