# Load the Rails application.
require_relative 'application'

app_config = YAML.load(File.read("#{Rails.root}/config/config.yml"))[Rails.env]
redis_instances = app_config["redis"]

REDIS_INSTANCE_LIST = {}
redis_instances.each do |redis_instance|
  redis_instance_info = YAML.load(File.read("#{Rails.root}/config/redis.yml"))[redis_instance[:instance_id]]
  REDIS_INSTANCE_LIST[redis_instance_info['hashcode']] = { :object => nil, :url => redis_instance_info['url'] }
end

# Initialize the Rails application.
Rails.application.initialize!
