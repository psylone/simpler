require_relative 'format/format'
require 'erb'

module Simpler

  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def check_format(bind_context)
      if (template.class == Hash)
        # пока только один формат, будем реализовывать без проверки ключа template.has_key?(:plain)
        PlainRenderer.new(@env).start
      else
        HTMLRenderer.new(@env).start(bind_context)
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

    def template_path
      path = template || [controller.name, action].join('/')
      @env['simpler.template'] = "#{VIEW_BASE_PATH}/#{path}.html.erb"
      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    def render(bind_context = nil)
      return "#{template[:plain]}\n" if bind_context.nil?
      template = File.read(template_path)

      ERB.new(template).result(bind_context)
    end
  end
end
