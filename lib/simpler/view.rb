require 'erb'
require 'json'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    RENDER_TYPE_DEFAULT = 'template'

    def initialize(env)
      @env = env
    end

    def render(binding)
      type = @env['simpler.template.type'] || RENDER_TYPE_DEFAULT
      send("render_#{type}", binding)
    end

    private

    def render_template(binding)
      @env['simpler.template_name'] = template_name

      template = File.read(template_path)
      ERB.new(template).result(binding)
    end
    
    def render_plain(binding)
      @env['simpler.template.data']
    end

    def render_json(binding)
      @env['simpler.template.data'].to_json
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

    def template_name
      path = template || [controller.name, action].join('/') # -> "tests/index"
      "#{path}.html.erb"
    end

    def template_path
      Simpler.root.join(VIEW_BASE_PATH, template_name)
    end

  end
end
