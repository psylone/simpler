require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      return plain if plain

      template = File.read(template_path)
      ERB.new(template).result(binding)
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

    def plain
      @env['simpler.plain']
    end

    def template_path
      path = template || [controller.name, action].join('/')
      template = "#{path}.html.erb"
      @env['simpler.render'] = template
      Simpler.root.join(VIEW_BASE_PATH, template)
    end

  end
end
