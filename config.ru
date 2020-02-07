require_relative 'config/environment'
require_relative 'lib/middleware/logger'

use SimplerLogger
run Simpler.application
