# frozen_string_literal: true

require 'pathname'
require_relative 'simpler/application'

# Simpler rack application
module Simpler
  class << self
    def application
      Application.instance
    end

    def root
      Pathname.new(File.expand_path('..', __dir__))
    end
  end
end
