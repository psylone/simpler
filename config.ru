require_relative 'config/environment'
require_relative 'lib/middleware/logger'

run Simpler.application
use AppLogger, logdev: File.expand_path('log/app.log', __dir__)
