require_relative 'middleware/custom_logger'
require_relative 'config/environment'

use CustomLogger, logdev: File.expand_path('log/app.log', __dir__)
run Simpler.application
