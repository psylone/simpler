require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze
    VIEW_FORMAT = '.erb'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      template = template_path

      if template.is_a?(Pathname)
        template = File.read(template)
      end

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

    def template_path
      path = template || [controller.name, action].join('/')
      if path.is_a?(Hash)
        "#{path[:plain]}".gsub(/^  /, '') if path.include?(:plain)
      else
        @env['simpler.view_path'] = "#{path}.html.erb"
        Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
      end
    end

  end
end
