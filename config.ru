require_relative 'lib/middleware/logger'
require_relative 'config/environment'

use Logger, "log/app.log"
run Simpler.application
