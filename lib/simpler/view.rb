require "erb"

module Simpler
  class View
    VIEW_BASE_PATH = "app/views".freeze

    def initialize(env)
      @env = env
    end

    def render(bind)
      custom = check_for_custom_template
      return custom unless custom.nil?

      template = File.read(template_path)

      ERB.new(template).result(bind)
    end

    private

    def controller
      @env["simpler.controller"]
    end

    def action
      @env["simpler.action"]
    end

    def template
      @env["simpler.template"]
    end

    def template_path
      path =  @template || [controller.name, action].join('/')
      @env['simpler.template_path'] = "#{path}.html.erb"
      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    def check_for_custom_template
      @template = template
      return nil unless @template.instance_of?(Hash)

      template_key = @template.keys[0]
      template_value = @template[template_key]

      case template_key
      when :plain then template_value
      end
    end
  end
end
