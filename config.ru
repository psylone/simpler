require_relative 'config/environment'
require_relative 'lib/request_logger'

use RequestLogger
run Simpler.application
