require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    # def render(binding, _format)
    #   template = File.read(template_path(_format))

    #   ERB.new(template).result(binding)
    # end

    def render(binding)
     # template = File.read(template_path(_format))
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

 #   def template_path(_format)
    def template_path
      # file_extension
      # file_extension 
      # "html"
      # path = template || [controller.name, action].join('/')

      # Simpler.root.join(VIEW_BASE_PATH, "#{path}.#{file_extension}.erb")
  #    Simpler.root.join(VIEW_BASE_PATH, "#{path}.#{file_extension}.html.erb")



      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
end
