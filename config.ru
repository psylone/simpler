require_relative 'config/environment'
require_relative 'middleware/app_logger'

use AppLogger, logfile: 'log/app.log'
run Simpler.application
