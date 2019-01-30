require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      # передаю везде биндинги чтобы переменные нормально отображались
      render_options(binding)
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

    def render_options(binding)
      if template.is_a?(Hash)
        render_raw
      else
        # если рендерим все как обычно render :index или "tests/index"
        render_from_file(binding)
      end
    end

    def render_raw
      "#{template.values[0]}\n"
    end

    def render_from_file(binding)
      template = File.read(template_path)
      ERB.new(template).result(binding)
    end
  end
end
