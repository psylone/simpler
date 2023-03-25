require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      template = render_body || File.read(template_path)

      ERB.new(template).result(binding)
    end

    private

    def render_body
      @env['simpler.body']
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

    def template_file_path
      return unless controller.name

      @env['simpler.file_path'] = [controller.name, action].join('/') + '.html.erb'
    end

    def template_path
      template_file_path

      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end
  end
end
