require_relative 'lib/simpler/middleware/logger'
require_relative 'config/environment'

use Simpler::Middleware::Logger
run Simpler.application
