require_relative 'config/environment'
require_relative 'middleware/app_logger'

use AppLogger, logdev: Simpler.root.join('log/app.log').to_path
run Simpler.application
