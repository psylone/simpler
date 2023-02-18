require_relative 'config/environment'

use Rack::Reloader, 0
use SimplerLogger, logdev: 'log/app.log'
run Simpler.application
