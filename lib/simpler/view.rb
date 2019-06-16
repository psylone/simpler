require 'erb'
require_relative 'view/plain_rendering'
require_relative 'view/html_rendering'
require_relative 'view/xml_rendering'

module Simpler
  class View
    RENDERING_CLASSES = { plain: PlainRendering, html: HTMLRendering, xml: XMLRendering }.freeze
    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      rendering_class = RENDERING_CLASSES[@env['simpler.response_type']]

      template_file = File.read(template_path) if File.file?(template_path)
      rendering_class.new(@env, template_file).render(binding)
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

    def response_type
      @env['simpler.response_type']
    end

    def template_path
      path = template || [controller.name, action].join('/')

      extention = case response_type
                  when :html then '.html.erb'
                  when :xml then '.xml.erb'
                  end
      Simpler.root.join(VIEW_BASE_PATH, "#{path}#{extention}")
    end

  end
end
