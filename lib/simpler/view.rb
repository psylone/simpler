require_relative 'view/html_render'
require_relative 'view/plain_render'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      render_template.result(binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def render_template
      template = @env['simpler.template']

      case template
      when String
        HtmlRender.new(template_path)
      when Hash
        PlainRender.new(template) if template.has_key?(:plain)
      else
        HtmlRender.new(template_path)
      end
    end

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end
  end
end
