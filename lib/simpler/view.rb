require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      {
        data: ERB.new(render_template).result(binding),
        template_path: @html_path
      }
    end

    private

    def render_template
      case template_type
      when :plain, :path
        template_path
      else
        File.read(template_path)
      end
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

    def template_type
      @env['simpler.template-type']
    end

    def template_path
      path = ''
      case template_type
      when :plain
        return template
      when :path
        path = template
      else
        path = [controller.name, action].join('/')
        @html_path = "#{path}.html.erb"
      end

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end
  end
end
