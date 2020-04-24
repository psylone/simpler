# frozen_string_literal: true

class RenderHtml
  VIEW_BASE_PATH = 'app/views'

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

  def template_path
    path ||= [controller.name, action].join('/')

    Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
  end
end
