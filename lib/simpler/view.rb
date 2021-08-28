require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      ERB.new(content).result(binding)
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

    def content
      if template.nil?
        path = [controller.name, action].join('/')

        Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
        File.read(Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb"))
      else
        template.values.join
      end
    end

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
end
