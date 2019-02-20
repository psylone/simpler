require_relative 'renderer/html_renderer.rb'
require_relative 'renderer/plain_renderer.rb'
require_relative 'renderer/json_renderer.rb'

module Simpler
  class View
    RENDERERS = {
      plain: PlainRenderer,
      json: JSONRenderer,
      html: HtmlRenderer
    }

    def initialize(env)
      detect_renderer(env)
    end

    def render(binding)
      @renderer.render(binding)
    end

    private

    def detect_renderer(env)
      mime_type = env['simpler.template']
      key = mime_type.nil? ? :html : mime_type.keys.first

      @renderer = RENDERERS[key].new(env)
    end
  end
end
