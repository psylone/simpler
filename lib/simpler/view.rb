require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(bindin)
      if template_hash?
        template_path

      else
        template = File.read(template_path)

        ERB.new(template).result(bindin)
      end
    end

    private

    def return_text

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
      if template_hash?
        template.values[0]
      else
        path = template || [controller.name, action].join('/')
        Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
      end
    end

    def template_hash?
      template.class == Hash
    end

  end
end
