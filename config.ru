require_relative 'lib/logger_http'
require_relative 'config/environment'

use LoggerHttp

run Simpler.application
