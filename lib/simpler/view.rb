require_relative 'renderers/html_renderer'
require_relative 'renderers/text_renderer'

module Simpler
  class View
    RENDERERS = { text: TextRenderer, html: HtmlRenderer }.freeze
    DEFAULT_RENDERER = HtmlRenderer

    def self.renderer(env)
      type = env['simpler.template'].keys.first if env['simpler.template'].is_a? Hash
      env['simpler.action'] = env['simpler.template'] if env['simpler.template'].is_a? String
      RENDERERS[type] || DEFAULT_RENDERER
    end

  end
end
