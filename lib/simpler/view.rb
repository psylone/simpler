require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      if template_path
        template = File.read(template_path)
        ERB.new(template).result(binding)
      else
        plain
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

    def plain
      @env['simpler.plain']
    end

    def template_path
      Simpler.root.join(VIEW_BASE_PATH, "#{template}.html.erb") if template
    end


  end
end
