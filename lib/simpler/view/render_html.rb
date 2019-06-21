require 'erb'

module Simpler
  class HtmlRender

    def initialize(env)
      @env = env
      @type = 'text/html'
      @path = ''
    end

    def result(binding)
      template = File.read(template_path)

      {type: @type,
       body: ERB.new(template).result(binding),
       template: @path}
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template_path
      @path = [controller.name, action].join('/') + '.html.erb'

      Simpler.root.join(View::VIEW_BASE_PATH, @path)
    end
  end
end
