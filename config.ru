# frozen_string_literal: true

require_relative 'config/environment'
require_relative 'lib/logger'

use Logger::Application
run Simpler.application
