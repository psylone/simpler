require 'erb'

module Simpler
  class View

    attr_reader :rendered_template

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
      @rendered_template = default_template_path
    end

    def render(binding)
      case template_type
      when :plain
        template[:plain]
      else
        puts "default_template_path = #{default_template_path}"
        template = File.read(default_template_path)
        ERB.new(template).result(binding)
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

    def default_template_path
      path = [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    def template_type
      return :nil if template.nil? || template.empty?
      return :plain if template.include?(:plain)
      return :default # otherwise
    end

  end
end
