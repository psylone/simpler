# frozen_string_literal: true

require_relative 'config/environment'

use RequestLogger
run Simpler.application
