require 'erb'

class HTMLRenderer

  VIEW_BASE_PATH = 'app/views'.freeze

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
    Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
  end

  def controller
    @env['simpler.controller']
  end

  def action
    @env['simpler.action']
  end

end