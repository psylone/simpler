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
      if template[:plain]
        generate_response(template[:plain])
      else template[:inline]
        generate_response(template[:inline])
      end
    end

    def generate_response(text)
      @response.write(ERB.new(text).result(binding))
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
