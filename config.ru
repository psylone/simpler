require_relative 'lib/middleware/logger'
require_relative 'config/environment'

use AppLogger, log_file: File.expand_path('log/app.log', __dir__)
run Simpler.application
