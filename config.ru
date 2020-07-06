require_relative 'config/environment'
require_relative 'lib/simpler/logger'

run Simpler.application
use AppLogger, log_file: File.expand_path('log/app.log', __dir__)
