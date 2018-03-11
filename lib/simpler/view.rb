require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      plain_response || template_response(binding)
    end

    private

    def plain_response
      @env['simpler.plain_response']
    end

    def template_response(binding)
      template = File.read(template_path)
      ERB.new(template).result(binding)
    end

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template_path
      path = template || [controller.name, action].join('/')
      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    def template
      @env['simpler.template']
    end

  end
end
