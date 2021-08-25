require_relative 'config/environment'
use SimplerLogger, logdev: File.expand_path('app/log/app.log', __dir__)
run Simpler.application
