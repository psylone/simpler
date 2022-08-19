require_relative 'config/environment'
require_relative "middlewares/logger"

use Log, logdev: File.expand_path("log/app.log", __dir__)
run Simpler.application
