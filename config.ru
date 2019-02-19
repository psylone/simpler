require_relative 'config/environment'
require_relative 'lib/middleware/logger'

use AppLog
run Simpler.application
