# frozen_string_literal: true

require_relative '../lib/simpler'
require_relative '../lib/middleware/request_logger'

Simpler.application.bootstrap!
