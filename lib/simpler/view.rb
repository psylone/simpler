require 'erb'
require_relative 'renderers/html_renderer'
require_relative 'renderers/plain_text_renderer'

module Simpler
  class View
    RENDERERS = { 'text/plain' => Renderers::PlainTextRenderer, 'text/html' => Renderers::HtmlRenderer }.freeze
    DEFAULT_RENDERER = RENDERERS[:html]

    def initialize(env)
      @env = env
    end

    def render(binding)
      renderer = RENDERERS[content_type] || DEFAULT_RENDERER
      renderer.new(@env).render(binding)
    end

    private

    def content_type
      @env['simpler.content_type']
    end
  end
end
