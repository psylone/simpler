# frozen_string_literal: true

require_relative 'plain_render'
require_relative 'json_render'
module Simpler
  class Render
    def initialize(format)
      @format = format
    end

    def call
      result = Object.const_get("#{@format.keys.join.capitalize}Render")
      result.new(@format)
    end
  end
end
