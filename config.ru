require_relative 'config/environment'
require_relative 'lib/simpler/app_logger'

use Rack::Reloader
use Simpler::AppLogger, logfile: Simpler.root.join('log/simpler.log')
run Simpler.application
