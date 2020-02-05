require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
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

    def content_type
      case @env['simpler.content_type']
      when :plain then 'text'
      else 'html'
      end
    end

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.#{content_type}.erb")
    end

  end
end
