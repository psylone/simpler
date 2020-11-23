require 'erb'
require_relative 'render/render_plain'
require_relative 'render/render_erb'

module Simpler
  class View

    def initialize(env)
      @render =
        case env['simpler.type_render']
        when :erb
          Simpler::RenderErb.new(env)
        when :plain
          Simpler::RenderPlain.new(env)
        end
    end

    def render(binding)
      @render.call(binding)
    end
  end
end
