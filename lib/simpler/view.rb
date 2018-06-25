require 'erb'
require_relative 'view/plain_renderer'
require_relative 'view/erb_renderer'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    RENDERERS = {plain: PlainRenderer}
    DEFAULT_RENDERER = ErbRenderer

    def initialize(env)
      @env = env
    end

    def render(binding)
      @renderer = get_renderer
      @renderer.new(@env).render(binding)
    end

    private

    def template
      @env['simpler.template']
    end

    def get_renderer
      if template.nil?
        return DEFAULT_RENDERER
      else
        template.each do |key, value|
          if RENDERERS.include?(key)
            return RENDERERS[key]
          end
        end
      end
    end
  end
end
