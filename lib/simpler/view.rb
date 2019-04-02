require_relative 'renderers/html'
require_relative 'renderers/text_plain'

module Simpler
  class View

    RENDERS  = { html: HtmlRender, plain: TextPlainRender }.freeze
    DEFAULT_RENDER =  HtmlRender

    def initialize(env)
      @env = env
    end

    def render(binding)
      render_type = RENDERS[template_type] || DEFAULT_RENDER
      render_type.new(@env).render(binding)
    end

    private

    def template_type
      @env['simpler.template_type']
    end
  end
end
