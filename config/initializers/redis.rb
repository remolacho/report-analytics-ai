require 'redis'
require 'connection_pool'

# Redis connection pool configuration
REDIS_POOL = ConnectionPool.new(size: 5, timeout: 5) do
  Redis.new(url: ENV['REDIS_URL'], db: ENV['REDIS_CACHE_DB'])
end

# Configure Redis as cache store
Rails.application.config.cache_store = :redis_cache_store, {
  url: ENV['REDIS_URL'],
  db: ENV['REDIS_CACHE_DB'],
  pool_size: 5,
  pool_timeout: 5,
  connect_timeout: 1,
  read_timeout: 1,
  write_timeout: 1,
  reconnect_attempts: 3,
  error_handler: -> (method:, returning:, exception:) {
    Rails.logger.error "Redis error: #{exception.class} - #{exception.message}"
    Sentry.capture_exception(exception) if defined?(Sentry)
  }
}
