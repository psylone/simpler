require_relative 'middleware/http_logger'
require_relative 'config/environment'

use HttpLogger
run Simpler.application
