require 'rails_helper'

RSpec.describe UrlLookupCache do
  describe 'Initialize UrlLookupCache' do
    it 'return redis object list' do
      redis_instance = UrlLookupCache.redis
      expect(redis_instance.length).to be 2
    end
  end
end
