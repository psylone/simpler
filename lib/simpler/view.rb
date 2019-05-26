require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      template =  if content.nil?
                    File.read(template_path)
                  else
                    content
                  end

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

    def content_type
      @env.header['Content-Type'] if @env.respond_to?(:header)
    end

    def content
      @env['simpler.content']
    end

    def format
      @env['simpler.format']
    end

    def template_path
      path = template || [controller.name, action].join('/')
      type = if content_type.nil? || content_type == 'text/html'
              'html'
            else
              content_type.gsub('text/', '')
            end

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.#{type}.erb")
    end

  end
end
