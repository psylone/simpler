require_relative 'config/environment'
require_relative 'lib/middleware/my_logger'

use MyLogger, 'log/app.log'
run Simpler.application

