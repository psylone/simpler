require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze
    ERROR_PATH = 'public/error.html.erb'

    def initialize(env)
      @env = env
    end

    def render(binding)
      template = File.read(template_path)

      ERB.new(template).result(binding)
    rescue
      File.read(ERROR_PATH)
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

    def view(path)
      @env['view'] = "#{path}.html.erb"
    end

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, view(path))
    end

  end
end
