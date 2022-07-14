require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      extend? ? extending_render : file_render(binding)
    end

    private

    def extending_render
      send(key_hash)
    end

    def key_hash
      @env['simpler.template'].keys[0]
    end

    def plain
      @env['simpler.template'].values[0] + "\n"
    end

    def file_render(binding)
      template = File.read(template_path)

      ERB.new(template).result(binding)
    end

    def extend?
      @env['simpler.template'].instance_of?(Hash)
    end

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
