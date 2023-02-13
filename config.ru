require_relative 'config/environment'

use Rack::Reloader, 0
run Simpler.application
