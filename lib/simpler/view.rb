require 'erb'
require_relative 'views/html_render'
require_relative 'views/plain_render'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'.freeze
    RENDERS = {
      'html' =>  Simpler::Views::HtmlRender,
      'plain' => Simpler::Views::PlainRender
    }.freeze

    def initialize(env)
      @env = env
    end

    def render(binding, type_render)
      if type_render
        RENDERS[type_render].new(template).result(binding)
      else
        RENDERS['html'].new(template_path).result(binding)
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

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end
  end
end
