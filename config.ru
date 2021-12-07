require_relative 'config/environment'

run Simpler.application
use AppLogger, logdev: File.expand_path('log/app.log', __dir__)

