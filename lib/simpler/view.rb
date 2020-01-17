require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      ERB.new(template_content).result(binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @template ||= @env['simpler.template'] || template_path.to_s
    end

    def template_content
      return File.read(template) if template.is_a?(String)
      return template[:plain] if template.is_a?(Hash) && template.include?(:plain)

      raise ArgumentError, "Unknown template format: #{template} "
    end

    def template_path
      path = [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
end
