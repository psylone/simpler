require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    RENDER_METHODS = {
      html: "render_html",
      plain: "render_plain",
      public: "render_public"
    }.freeze

    def initialize(env)
      @env = env
    end

    def render(binding_from_controller)
      render_method = @env['simpler.render_option'] || :html

      send(RENDER_METHODS[render_method], binding_from_controller)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def render_html(binding_from_controller)
      template = File.read(template_path)

      ERB.new(template).result(binding_from_controller)
    end

    def render_plain(_binding_from_controller)
      render_option_value
    end

    def render_option_value
      @env['simpler.render_option_value']
    end

    def render_public(_binding_from_controller)
      path = Simpler.root.join(VIEW_BASE_PATH, "public/#{render_option_value}.html")

      File.read(path)
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
