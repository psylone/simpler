require_relative 'lib/middleware/simpler_logger'
require_relative 'config/environment'

use LoggerMiddleware, Logger: File.expand_path('log/app.log', __dir__)
run Simpler.application
