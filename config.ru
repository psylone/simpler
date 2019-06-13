require_relative 'lib/middleware/logger'
require_relative 'config/environment'

use SimplerLogger, "log/app.log"
run Simpler.application
