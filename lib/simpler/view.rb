require_relative 'view/html_renderer'
require_relative 'view/plain_renderer'

module Simpler
  class View
    TYPES = {plain: '.text', json: '.json', html: '.html'}.freeze

    VIEW_BASE_PATH = 'app/views'.freeze
    attr_reader :renderer
    def initialize(env)
      @env = env
    end

    def render(bind)
      template = File.read(template_path)
      @renderer = set_renderer(template, bind)
      # byebug
      @renderer.render
    end

   private

    def set_renderer(template, bind)
      context = @env['simpler.render_template'][:plain]
      if context.nil?
        HtmlRenderer.new(template, bind)
      else
        PlainRenderer.new(context, bind)
      end

    end

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template_path']
    end

    def template_path
      path = template || [controller.name, action].join('/')
      @env['simpler.template_path'] = path
      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end
  end
end
