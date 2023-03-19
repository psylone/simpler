require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      render_template(binding)
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
      @env['simpler.template_path'] = "#{path}.html.erb"

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    def html_render(binding)
      template = File.read(template_path)

      ERB.new(template).result(binding)
    end

    def render_template(binding)
      template = @env['simpler.template']

      if template.is_a?(Hash) && template.has_key?(:plain)
        "#{@env['simpler.template'][:plain]}\n"
      else
        html_render(binding)
      end
    end

  end
end
