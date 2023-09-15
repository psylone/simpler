require_relative 'config/environment'
require_relative 'lib/logging/logging'

use Logging
run Simpler.application
