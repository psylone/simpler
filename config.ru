require_relative 'config/environment'
require_relative 'lib/middleware/logger'

use LoggerMiddleware
run Simpler.application
