require_relative 'lib/middleware/logger'
require_relative 'config/environment'

use Rack::Reloader
use AppLoger, logdev: File.expand_path('log/app.log', __dir__)
run Simpler.application
