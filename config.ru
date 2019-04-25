require_relative 'config/environment'
require_relative 'lib/middleware/logger'

use SimplerLogger, logfile: File.expand_path('log/access.log', __dir__)
run Simpler.application
