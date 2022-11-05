require_relative 'middleware/logger'
require_relative 'config/environment'

use AppLogger
run Simpler.application
