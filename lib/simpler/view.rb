require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    attr_reader :used_template, :content_type

    def initialize(env)
      @env = env
      @used_template = template_path
      @content_type = 'text/html'
    end

    def render(binding)
      return plain_render if template.is_a?(Hash) && template.has_key?(:plain)
      template_file = File.read(@used_template)

      ERB.new(template_file ).result(binding)
    end

    private

    def plain_render
      @content_type = 'text/plain'
      template[:plain]
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

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
end
