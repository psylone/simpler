require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env, render_type)
      @env = env
      @render_type = render_type
    end

    def render(binding)
      case @render_type
      when 'plain'
        template
      else
        template = File.read(template_path)
        ERB.new(template).result(binding)
      end
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

      @env['simpler.view_path'] = "#{path}.html.erb"

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end
  end
end
