require 'redis'

# Use a block to handle potential connection errors during boot
begin
  $redis = Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
  
rescue StandardError => e
  Rails.logger.error "Redis initialization failed: #{e.message}"
  $redis = nil
end