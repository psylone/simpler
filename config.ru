require_relative 'config/environment'

use Rack::Reloader
run Simpler.application
