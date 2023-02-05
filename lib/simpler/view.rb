require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      # template = File.read(template_path)
      template = plain_text || File.read(template_path)

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

    def plain_text
      @env['simpler.render_handler'] = 'RENDER_METHOD: plain_text'
      @env['simpler.plain_text']
    end

    def template_path
      # path = template || [controller.name, action].join('/')
      
      # path = @env['simpler.template_path']
      # x = path || [controller.name, action].join('/')
      # Simpler.root.join(VIEW_BASE_PATH, "#{x}.html.erb")
      
      @env['simpler.template_path'] = path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
end
