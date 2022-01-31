require_relative 'config/environment'
require_relative 'middleware/logger'

use AppLogger, logdev: File.expand_path('log/app.log', __dir__)
run Simpler.application
