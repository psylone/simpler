require_relative 'view/base_render'
require_relative 'view/erb_render'
require_relative 'view/plain_render'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      template = template_inline || File.read(template_path)
      render_class.new(template).render(binding)
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

    def template_render
      @env['simpler.template.render'] || 'erb'
    end

    def template_inline
      @env['simpler.template.inline']
    end

    def render_class
      View.const_get("#{template_render.capitalize}Render")
    end

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.#{template_render}")
    end

  end
end
