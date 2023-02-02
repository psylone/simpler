require_relative "config/environment"
require_relative "lib/simpler/middleware/logger"

use Simpler::AppLogger, logdev: File.expand_path("log/app.log", Simpler.root)
run Simpler.application
