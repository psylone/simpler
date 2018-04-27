require_relative 'config/environment'
require_relative 'lib/middleware/simpler_logger'

use SimplerLogger
run Simpler.application
