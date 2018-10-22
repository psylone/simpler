require 'erb'
require_relative '../renderer'

module Simpler
  class HtmlRenderer < Renderer

    VIEW_BASE_PATH = './app/views'.freeze

    def render(binding)
      template_response(binding)
    end

    private

    def template_response(binding)
      template = File.read(template_path)
      ERB.new(template).result(binding)
    end

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template_path
      path = template || [controller.name, action].join('/')
      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    def template
      @render_params
    end

  end
end
