# frozen_string_literal: true

require 'erb'

module Simpler
  # View renderer for rack application
  class View
    VIEW_BASE_PATH = 'app/views'

    def initialize(env)
      @env = env
    end

    def render(binding)
      return plain if plain?

      @env['simpler.template_path'] = short_template_path
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

    def plain
      @env['simpler.plain']
    end

    def plain?
      plain
    end

    def short_template_path
      template || [controller.name, action].join('/')
    end

    def template_path
      Simpler.root.join(VIEW_BASE_PATH, "#{short_template_path}.html.erb")
    end
  end
end
