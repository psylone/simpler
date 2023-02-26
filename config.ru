require_relative 'config/environment'
require_relative 'middleware/logger'

use Logger

run Simpler.application
