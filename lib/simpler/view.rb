require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'

    def initialize(env)
      @env = env
    end

    def render(binding)
      choose_template(binding)
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

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    def choose_template(binding)
      template = @env['simpler.template']

      if template.instance_of?(String)
        template = File.read(template_path)
        ERB.new(template).result(binding)
      elsif template.instance_of?(Hash) && template.keys[0] == :plain
        template[:plain]
      end
    end
  end
end
