require_relative 'lib/middleware/s_logger.rb'
require_relative 'config/environment'

use Middleware::SLogger, logdev: File.expand_path('log/app.log', __dir__)
run Simpler.application
