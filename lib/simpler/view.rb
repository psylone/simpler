require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      if template_to_plain_text
        ERB.new(template_to_plain_text).result(binding)
      else
        template = File.read(template_path)
        ERB.new(template).result(binding)
      end
    end

    private

     def template_to_plain_text
      @env['simpler.plain_text']
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

    def view(path)
      @env['simpler.view_file'] = "#{path}.html.erb"
    end

    def template_path
      path = template || [controller.name, action].join('/')
       @env['simpler.template_path'] = "#{path}.html.erb"
      Simpler.root.join(VIEW_BASE_PATH, view(path))
    end

  end
end
