require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    attr_reader :used_template

    def initialize(env)
      @env = env
      @used_template = template_path
    end

    def render(binding)
      template = File.read(@used_template)

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

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
end
