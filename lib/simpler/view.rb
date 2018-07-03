require 'erb'
require_relative 'view/plain_renderer'
require_relative 'view/html_renderer'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    RENDERERS = {"text/plain": PlainRenderer, "text/html": HtmlRenderer}
    DEFAULT_RENDERER = HtmlRenderer

    def initialize(env)
      @env = env
    end

    def render(binding)
      @renderer = get_renderer(@env)
      @renderer.new(@env).render(binding)
    end

    private

    def template
      @env['simpler.template']
    end

    def get_renderer(env)
      if template.nil?
        return DEFAULT_RENDERER
      else
        RENDERERS[env['Content-Type']]
      end
    end
  end
end
