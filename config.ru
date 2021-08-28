require_relative 'config/environment'
require_relative 'lib/middleware/http_logger'

use HttpLogger
run Simpler.application
