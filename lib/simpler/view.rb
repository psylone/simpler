require 'erb'
require_relative 'view/template/plain_render'
require_relative 'view/template/html_render'

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

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    def render_template
      template = @env['simpler.template']

      case template
      when String
        HTMLRender.new(template_path)
      when Hash
        PlainRender.new(template) if template.has_key?(:plain)
      else
        HTMLRender.new(template_path)
      end
    end

  end
end
