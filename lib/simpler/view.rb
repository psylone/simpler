require 'erb'
require_relative 'render/plain'
require_relative 'render/html'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env, render_type)
      @env = env
      @render_type = render_type
    end

    def render(binding)
      view_render.result(binding)
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
      render = "#{path}.html.erb"
      @env['simpler.render'] = render
      Simpler.root.join(VIEW_BASE_PATH, render)
    end

    def view_render
      return Object.const_get(@render_type.capitalize).new(template) unless @render_type.nil?

      Html.new(template_path)
    end

  end
end
