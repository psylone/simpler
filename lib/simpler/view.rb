require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      ERB.new(str_from_template).result(binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template'] # plain: 'text'
    end

    def template_path
      path = template || [controller.name, action].join('/')
      @env["simpler.view"] = "#{path}.html.erb" unless template

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    def str_from_template
      if template.is_a? Hash
        template.first.last
      else
        File.read(template_path)
      end
    end

  end
end
