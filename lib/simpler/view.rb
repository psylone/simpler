require_relative 'renderers/html_renderer'
require_relative 'renderers/plain_renderer'

module Simpler
  class View
    def initialize(env)
      @render_options = env['simpler.template']

      select_renderer(env)
    end

    def render(binding)
      @renderer.render(binding)
    end

    private

    def select_renderer(env)
      @renderer = case @render_options
                  when Hash
                    PlainRenderer.new(env)
                  else
                    HtmlRenderer.new(env)
                  end
    end
  end
end
