require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
      @response = Rack::Response.new
    end

    def render(binding)
      if @env['simpler.template']
        template = @env['simpler.template']
        other_format(template)
      else
        template = File.read(template_path)
        ERB.new(template).result(binding)
      end
    end

    def other_format(template)
      if template[:plain] || template[:inline]
        @response.write(ERB.new(template.values.first).result(binding))
      else
        @response.write(ERB.new("format not known\n").result(binding))
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

      @env['simpler.render_view'] = "#{path}.html.erb"

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
end
