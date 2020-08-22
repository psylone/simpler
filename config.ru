require_relative 'lib/logger'
require_relative 'config/environment'
use HTTPLogger

run Simpler.application
