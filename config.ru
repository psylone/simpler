require_relative 'config/environment'
require_relative 'lib/middleware/logger'

use AppLogger, logdev: Simpler.root.join('log/app.log')
run Simpler.application
