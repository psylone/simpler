require_relative 'config/environment'

use AppLogger, path: File.expand_path('log/app.log', __dir__)
run Simpler.application
