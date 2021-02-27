require 'erb'
require_relative 'render/plain_render.rb'
require_relative 'render/html_render.rb'

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
      @render_type == 'plain' ? PlainRender.new(template) : HtmlRender.new(template_path)
    end

  end
end
