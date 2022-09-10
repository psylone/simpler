# frozen_string_literal: true

require_relative 'config/environment'
require_relative 'middleware/log'

use Log, log_path: File.expand_path('log/app.log', __dir__)

run Simpler.application
