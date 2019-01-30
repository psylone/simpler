require 'erb'

class HtmlRenderer
  VIEW_BASE_PATH = 'app/views'.freeze

  def initialize(env)
    @env = env
  end

  def render(binding)
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

  def template_path
    path = template || [controller.name, action].join('/')
    file = "#{path}.html.erb"
    @env['simpler.template_path'] = file

    Simpler.root.join(VIEW_BASE_PATH, file)
  end
end
