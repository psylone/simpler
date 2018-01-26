require_relative 'renderers/plain_renderer'
require_relative 'renderers/html_renderer'

module Simpler
  class View
    RENDERERS = { plain: PlainRenderer, html: HTMLRenderer }

    def self.renderer(env)
      if env['simpler.template']
        type = env['simpler.template'].keys.first
        RENDERERS[type]
      else
        RENDERERS[:html]
      end
    end

  end
end
