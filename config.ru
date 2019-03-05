require_relative 'config/environment'
require_relative 'middleware/logger'

use SimplerLogger, logdev: File.expand_path('log/simpler.log', __dir__)
run Simpler.application
