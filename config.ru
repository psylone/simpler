require_relative 'config/environment'
require_relative 'lib/middleware/applogger'

use AppLogger, logdev: File.expand_path('app/log/app.log', __dir__)
run Simpler.application
