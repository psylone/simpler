require_relative 'config/environment'
use AppLogger, logdev: File.expand_path('log/app.log', __dir__)
run Simpler.application
