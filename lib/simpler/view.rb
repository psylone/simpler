require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)

      ERB.new(template_data).result(binding)
    end

    private

    def template_data
      if template.nil?
        path = [controller.name, action].join('/')
        @env['simpler.template_path_view'] = "#{path}.html.erb"

        Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
        File.read(Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb"))
      else
        template.values.join
      end
    end

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

  end
end
