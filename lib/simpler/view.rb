require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      if template.is_a?(Hash)
        template.values[0]
      else
        render_partial(binding)
      end
    end

    private

    def render_partial(binding)
      template = File.read(template_path)

      ERB.new(template).result(binding)
    end

    def template
      @env['simpler.template']
    end

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template_path
      path = template || [controller.name, action].join('/')
      @env['simpler.template_path'] = "#{path}.html.erb"

      Simpler.root.join(VIEW_BASE_PATH, @env['simpler.template_path'])
    end
  end
end