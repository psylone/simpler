# frozen_string_literal: true

require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'

    def initialize(env)
      @env = env
    end

    def render(binding)
      template = File.read(template_path)

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
      path = "#{path}.#{define_format}.erb"
      pp define_format
      @env['simpler.rendered_template'] = path
      Simpler.root.join(VIEW_BASE_PATH, path)
    end

    def define_format
      @env['simpler.type'] == :json ? 'json' : 'html'
    end
  end
end
