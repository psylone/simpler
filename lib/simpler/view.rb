require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
      @templates = { plain: Hash.new { |hash, value| hash[value] = ERB.new(value) } }
    end

    def render(binding)
      template = @env['simpler.template'].to_a.flatten
      if @templates[template[0]]
        @templates[template[0]][template[1]].result(binding)
      else
        template = File.read(template_path)
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

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
end
