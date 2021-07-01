require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      return "#{template[:plain]}\n" if template.is_a?(Hash) && template.key?(:plain)
      
      template_file = File.read(template_path)
      ERB.new(template_file).result(binding)
    end

    private

    attr_reader :env

    def controller
      env['simpler.controller']
    end

    def action
      env['simpler.action']
    end

    def template
      env['simpler.template']
    end

    def template_path
      path = template || [controller.name, action].join('/')
      env['simpler.template_path'] = File.join(VIEW_BASE_PATH, "#{path}.html.erb")
      Simpler.root.join(env['simpler.template_path'])
    end

  end
end
