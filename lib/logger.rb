# frozen_string_literal: true

require 'pathname'
require_relative 'logger/application'

# Logger for Simpler
module Logger
  class << self
    def root
      Pathname.new(File.expand_path('..', __dir__))
    end
  end
end
