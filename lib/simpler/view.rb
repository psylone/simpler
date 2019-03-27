require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      if template || response_type.nil?
        template = File.read(template_path)

        ERB.new(template).result(binding)
      else
        response_data if response_type == :plain
      end
    end

    private

    def response_type
      @env['simpler.response_type']
    end

    def response_data
      @env['simpler.response_data']
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
