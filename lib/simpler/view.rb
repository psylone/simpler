require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      case template
      when Hash
        template[:plain] if template.has_key?(:plain)
      else  
        template_file = File.read(template_path)

        ERB.new(template_file).result(binding)
      end
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
      @env['simpler.template'] = "#{path}.html.erb"

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
end
