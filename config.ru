require_relative 'middleware/simpler_logger'
require_relative 'config/environment'

use SimplerLogger, logdev: File.expand_path('log/app.log',__dir__)
run Simpler.application
