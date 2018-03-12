require 'erb'

class HtmlRenderer

  VIEWS_PATH = 'app/views'.freeze

  def initialize(env)
    @env = env
  end

  def render(binding)
    view = File.read(view_path)
    ERB.new(view).result(binding)
  end

  private

  def view_path
    path = [controller.name, action].join('/')
    @env['simpler.view_path'] = "#{path}.html.erb"
    Simpler.root.join(VIEWS_PATH, @env['simpler.view_path'])
  end

  def controller
    @env['simpler.controller']
  end

  def action
    @env['simpler.action']
  end

end