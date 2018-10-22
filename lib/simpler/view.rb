require_relative 'renderer'
require_relative 'renderers/html_renderer'
require_relative 'renderers/plain_renderer'

module Simpler
  class View

    def initialize(env)
      render_params = env['simpler.render_params']

      case render_params
      when String # render template
        @renderer = HtmlRenderer.new(env)
      when nil # render action template
        @renderer = HtmlRenderer.new(env)
      when Hash
        if render_params.keys.include?(:plain)
          @renderer = PlainRenderer.new(env)
        end
        # JsonRenderer, etc...
      end
    end

    def render(binding)
      @renderer.render(binding)
    end

  end
end
