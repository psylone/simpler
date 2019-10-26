require_relative 'view/html_renderer'
require_relative 'view/plain_renderer'

module Simpler
  class View

    RENDERERS = {
      html: HTMLRenderer,
      plain: PlainRenderer
    }

    DEFAULT_RENDERER = HTMLRenderer

    def self.renderer(env)
      type = env['simpler.template'].keys.first if env['simpler.template'].is_a?(Hash)

      RENDERERS[type] || DEFAULT_RENDERER
    end
  end
end
