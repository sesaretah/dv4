# config/initializers/logger_patch.rb
require "logger"

module ActiveSupport
  module LoggerThreadSafeLevel
    Logger = ::Logger # Patch the missing constant
  end
end