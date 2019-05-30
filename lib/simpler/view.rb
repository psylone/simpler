require_relative 'view/default_renderer'
require_relative 'view/plain_renderer'
module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      renderer.render(binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def source
      @env['simpler.render_source']
    end

    def default_path
      [controller.name, action].join('/')
    end

    def renderer
      if source && source.is_a?(Hash) && source.key?(:plain)
        PlainRenderer.new(source[:plain])
      else
        DefaultRenderer.new(source || default_path)
      end
    end
  end
end
