require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      return @env['simpler.template'][:plain] if Controller.template_plain?(@env)
      template = File.read(template_path)

      ERB.new(template).result(binding)
    end

    def template_path_relative
      "#{[controller.name, action].join('/')}.html.erb"
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

  end
end
