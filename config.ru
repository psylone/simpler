require_relative 'config/environment'
require_relative "middlewares/logger"

use Log
run Simpler.application
