require_relative 'middleware/logger'
require_relative 'config/environment'

use SimplerLogger, logdev: File.expand_path(Simpler.root.join('log/app.log'))
run Simpler.application
