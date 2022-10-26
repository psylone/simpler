require_relative 'view/view_render'

module Simpler
  class View
    include ViewRender

    def initialize(env)
      @env = env
    end

    def render(binding)
      send("render_#{type_of_render.to_s}".to_sym, binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def render_options
      @env['simpler.render_options']
    end

    def type_of_render
      render_options.keys.first
    end

    def rendering_value
      render_options[type_of_render]
    end
  end
end
