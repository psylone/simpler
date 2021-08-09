require_relative 'config/environment'
require_relative 'lib/simpler/app_logger'

use Simpler::AppLogger, file_path: Simpler.root.join('log/app.log')
run Simpler.application
