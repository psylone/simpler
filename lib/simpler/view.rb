require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      if template || respond_type.nil?
        str_template = File.read(template_path)
        ERB.new(str_template).result(binding)
      else
        respond_value if respond_type == :plain
      end

    end

    private

    def respond_type
      @env['simpler.respond_type']
    end

    def respond_value
      @env['simpler.respond_value']
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
