require_relative 'config/environment'
require_relative 'lib/middleware/logger'

use SimplerLogger, logdev: File.expand_path('lib/log/log.log', __dir__)
run Simpler.application
